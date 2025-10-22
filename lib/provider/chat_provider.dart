

import 'package:chatme/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) => ChatService(FirebaseFirestore.instance));


