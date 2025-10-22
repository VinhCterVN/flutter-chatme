import 'dart:developer';

import 'package:chatme/data/model/chat_model.dart';
import 'package:chatme/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType { private, group }

class ChatService {
  final FirebaseFirestore _firestore;

  ChatService(this._firestore);

  Future<dynamic> getChatList() async {
    try {
      final snapshot = await _firestore.collection('chats').orderBy('lastMsgTime', descending: true).get();

      return snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      log('Error fetching chat list: $e');
      return "Error fetching chat list: ${e.toString()}";
    }
  }

  Future<Map<String, dynamic>> createChat(List<String> users, {ChatType? type, String? createdBy}) async {
    final isPrivate = (type ?? (users.length > 2 ? ChatType.group : ChatType.private)) == ChatType.private;
    final pairKey = isPrivate ? makePairKey(users[0], users[1]) : null;

    final ref = await _firestore.collection('chats').add({
      'type': (type ?? (users.length > 2 ? ChatType.group : ChatType.private)).name,
      'participants': users
          .map((userId) => {'userId': userId, 'role': Role.member.name, 'joinedAt': FieldValue.serverTimestamp()})
          .toList(),
      'participantIds': users..sort(),
      if (pairKey != null) 'pairKey': pairKey,

      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy ?? users.first,
      'lastMsg': null,
      'lastMsgId': null,
      'lastMsgTime': null,
    });

    return {
      'id': ref.id,
      'type': (isPrivate ? ChatType.private : ChatType.group).name,
      'participants': users,
      'createdAt': DateTime.now().toIso8601String(),
      'createdBy': createdBy ?? users.first,
    };
  }

  Future<dynamic> sendMessage({
    required String chatId,
    required String message,
    required String senderId,
    List<String>? participants,
  }) async {
    try {
      if (message.isEmpty || senderId.isEmpty) {
        return "Message and sender ID must not be empty.";
      }

      if (chatId.isEmpty) {
        if (participants == null || participants.isEmpty) {
          return "participants is required when chatId is empty.";
        }
        final created = await createChat(participants, createdBy: senderId);
        chatId = created['id'] as String;
      }

      final ref = _firestore.collection('chats').doc(chatId);

      final chatSnap = await ref.get();
      if (!chatSnap.exists) {
        if (participants == null || participants.isEmpty) {
          return "Chat does not exist. Please provide participants to create the chat.";
        }
        final created = await createChat(participants, createdBy: senderId);
        chatId = created['id'] as String;
      }

      final result = await _firestore.runTransaction((tx) async {
        final chatRef = _firestore.collection('chats').doc(chatId);
        final messagesCol = chatRef.collection('messages');

        final newMsgRef = messagesCol.doc();
        final messageData = {
          'senderId': senderId,
          'content': message,
          'type': MessageType.text.name,
          'createdAt': FieldValue.serverTimestamp(),
          'status': MessageStatus.sent.name,
        };

        tx.set(newMsgRef, messageData);

        tx.set(chatRef, {
          'lastMsg': message,
          'lastMsgTime': FieldValue.serverTimestamp(),
          'lastMsgId': newMsgRef.id,
        }, SetOptions(merge: true));

        return {'chatId': chatId, 'id': newMsgRef.id, ...messageData};
      });

      return result;
    } catch (e) {
      log('Error sending message: $e');
      return "Error sending message: ${e.toString()}";
    }
  }

  Future<dynamic> getGroupChat(String chatId) async {
    final dynamic data = await _firestore
        .collection('chats')
        .doc(chatId)
        .get()
        .then((doc) {
          if (doc.exists) {
            final chatData = doc.data()!;
            return {
              'id': doc.id,
              ...chatData,
              'type': ChatType.group.name,
              'participants': chatData['participants'] as List<dynamic>,
              'messages': chatData['messages'] as List<dynamic>?,
            };
          } else {
            return "Chat not found.";
          }
        })
        .catchError((e) {
          log('Error fetching group chat: $e');
          return "Error fetching group chat: ${e.toString()}";
        });

    return data;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getPrivateChat(
      String uidA,
      String uidB,
      ) async {
    final key = makePairKey(uidA, uidB);
    final snap = await _firestore
        .collection('chats')
        .where('type', isEqualTo: 'private')
        .where('pairKey', isEqualTo: key)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty ? snap.docs.first : null;
  }

  String makePairKey(String a, String b) {
    final sorted = [a, b]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
