import 'dart:convert';
import 'dart:developer';

import 'package:chatme/data/model/chat_model.dart';
import 'package:chatme/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChatType { private, group }

class ChatService {
  final FirebaseFirestore _firestore;

  ChatService(this._firestore);

  Stream<List<Chat>> streamChatList(WidgetRef ref) {
    final userService = ref.read(userServiceProvider);
    final currentUser = FirebaseAuth.instance.currentUser!;
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('lastMsgTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = await Future.wait(
            snapshot.docs.map((d) async {
              final data = d.data();
              final type = data['type'] == ChatType.private.name ? ChatType.private : ChatType.group;

              final participants = List<String>.from(data['participants'] as List<dynamic>);
              String? groupName;

              if (type == ChatType.private) {
                final users = await userService.getUsersByIds(participants);
                groupName = users.firstWhere((u) => u.uid != currentUser.uid).displayName;
              } else {
                groupName = data['groupName'] as String?;
              }

              return Chat(
                id: d.id,
                type: type,
                participants: participants,
                groupName: groupName,
                groupAvatarUrl: data['groupAvatarUrl'] as String?,
                lastMsg: data['lastMsg'] as String?,
                lastMsgSenderId: data['lastMsgSenderId'] as String?,
                lastMsgTime: data['lastMsgTime'] as Timestamp?,
                createdAt: data['createdAt'] as Timestamp,
              );
            }).toList(),
          );

          return chats;
        });
  }

  Future<String> _getPrivateGroupName(List<String> participants, WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser;
    final userService = ref.read(userServiceProvider);

    final users = await userService.getUsersByIds(participants);
    return users.firstWhere((e) => e.uid != user?.uid).displayName;
  }

  Future<dynamic> getOrCreatePrivate({required String uuidA, required String uuidB}) async {
    final roomId = makePairKey(uuidA, uuidB);
    try {
      final doc = await _firestore.collection('chats').doc(roomId).get();
      if (!doc.exists) {
        await _firestore.collection('chats').doc(roomId).set({
          'type': ChatType.private.name,
          'participants': [uuidA, uuidB],
          'lastMsg': null,
          'lastMsgTime': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      final chatDoc = await _firestore.collection('chats').doc(roomId).get();
      final chatData = chatDoc.data()!;
      return Chat(
        id: chatDoc.id,
        type: ChatType.private,
        participants: List<String>.from(chatData['participants'] as List<dynamic>),
        createdAt: chatData['createdAt'] as Timestamp,
      );
    } catch (e) {
      log('Error in getOrCreatePrivate: $e');
      return "Error in getOrCreatePrivate: ${e.toString()}";
    }
  }

  Future<dynamic> fetchRoomData(String roomId) async {
    try {
      final doc = await _firestore.collection('chats').doc(roomId).get();
      if (!doc.exists) {
        return "Chat room not found.";
      }
      final chatData = doc.data()!;
      return Chat(
        id: doc.id,
        type: chatData['type'] == ChatType.private.name ? ChatType.private : ChatType.group,
        participants: List<String>.from(chatData['participants'] as List<dynamic>),
        groupName: chatData['groupName'] as String?,
        groupAvatarUrl: chatData['groupAvatarUrl'] as String?,
        createdAt: chatData['createdAt'] as Timestamp,
      );
    } catch (e) {
      log('Error fetching room data: $e');
      return "Error fetching room data: ${e.toString()}";
    }
  }

  Future<List<ChatMessage>> fetchChatMessages(String roomId) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      return snapshot.docs.map((d) {
        final data = d.data();
        return ChatMessage(
          id: d.id,
          senderId: data['senderId'],
          content: data['content'],
          timestamp: (data['createdAt'] as Timestamp),
        );
      }).toList();
    } catch (e) {
      log('Error fetching chat messages: $e');
      return [];
    }
  }

  Future<void> sendMessage(String roomId, String senderId, String content) async {
    try {
      final timestamp = Timestamp.now();
      await _firestore.collection('chats').doc(roomId).collection('messages').add({
        'senderId': senderId,
        'content': content,
        'timestamp': timestamp,
      });
      await _firestore.collection('chats').doc(roomId).update({
        'lastMsg': content,
        'lastMsgSenderId': senderId,
        'lastMsgTime': timestamp,
      });
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  Stream<List<ChatMessage>> streamMessages(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage(
              id: doc.id,
              senderId: data['senderId'] as String,
              content: data['content'] as String,
              timestamp: (data['timestamp'] as Timestamp),
            );
          }).toList(),
        );
  }

  String makePairKey(String a, String b) {
    final sorted = [a, b]..sort();
    return sha1.convert(utf8.encode("${sorted[0]}_${sorted[1]}")).toString().substring(0, 20);
  }
}
