
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final MessageStatus status;
  final List<Reader> readers;
  final List<Reaction> reactions;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.status,
    this.readers = const [],
    this.reactions = const [],
  });
}

class Reader {
  final String userId;
  final DateTime readAt;

  Reader({required this.userId, required this.readAt});
}

class Reaction {
  final String userId;
  final String emoji;
  final DateTime reactedAt;

  Reaction({
    required this.userId,
    required this.emoji,
    required this.reactedAt,
  });
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}

enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
}