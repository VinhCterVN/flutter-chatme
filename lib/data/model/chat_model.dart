import '../../service/chat_service.dart';

class Chat {
  final String? id;
  final ChatType type;
  final String? groupName;
  final List<Participant> participants;
  final DateTime createdAt;
  final String createdBy;
  final String? lastMsg;
  final DateTime? lastMsgTime;
  final String? lastMsgId;

  Chat({
    required this.type,
    required this.participants,
    required this.createdAt,
    required this.createdBy,
    this.id,
    this.groupName,
    this.lastMsg,
    this.lastMsgId,
    this.lastMsgTime,
  });
}

class Participant {
  final String userId;
  final Role role;
  final DateTime joinedAt;

  Participant({required this.userId, required this.role, required this.joinedAt});
}

enum Role { admin, member }
