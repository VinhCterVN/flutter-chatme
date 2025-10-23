import '../../service/chat_service.dart';

class Chat {
  final String id;
  final ChatType type;
  final List<String> participants;
  List<ChatMember>? groupMembers;
  final List<ChatMessage>? messages;
  final String? lastMsg;
  final DateTime? lastMsgTime;
  final String? groupName;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.type,
    required this.participants,
    this.groupMembers,
    this.messages,
    this.lastMsg,
    this.lastMsgTime,
    this.groupName,
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
  final DateTime? createdAt;

  ChatMessage({required this.id, required this.senderId, required this.content, required this.createdAt});
}

enum Role { admin, member }
