import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/chat_service.dart';

class Chat {
  final String id;
  final ChatType type;
  final List<String> participants;
  List<ChatMember>? groupMembers;
  final String? lastMsg;
  final Timestamp? lastMsgTime;
  final String? groupName;
  final String? groupAvatarUrl;
  final Timestamp createdAt;

  Chat({
    required this.id,
    required this.type,
    required this.participants,
    this.groupMembers,
    this.lastMsg,
    this.lastMsgTime,
    this.groupName,
    this.groupAvatarUrl,
    required this.createdAt,
  });

  void setGroupMembers(List<ChatMember> members) {
    if (type == ChatType.group) {
      groupMembers = members;
    }
  }
}

class GroupParticipant {
  final String userId;
  final Role role;
  final DateTime joinedAt;

  GroupParticipant({required this.userId, this.role = Role.member, required this.joinedAt});
}

class ChatMember {
  final String userId;
  final String displayName;
  final String photoUrl;

  ChatMember({required this.userId, required this.displayName, required this.photoUrl});
}

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final Timestamp timestamp;

  ChatMessage({required this.id, required this.senderId, required this.content, required this.timestamp});
}

enum Role { admin, member }
