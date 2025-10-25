import 'dart:developer';

import 'package:chatme/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/chat_model.dart';

/// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) => ChatService(FirebaseFirestore.instance));

/// Provider for streaming chat list
final messagesStreamProvider = StreamProvider.autoDispose.family<List<ChatMessage>, String>((ref, roomId) {
  final chatService = ref.watch(chatServiceProvider);
  ref.onDispose(() {
    log("Disposing messages stream for roomId: $roomId");
  });
  return chatService.streamMessages(roomId);
});
