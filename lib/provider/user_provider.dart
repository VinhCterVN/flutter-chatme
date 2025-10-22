import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/user_service.dart';

/// Provider for UserService
final userServiceProvider = Provider<UserService>((ref) => UserService(FirebaseFirestore.instance));
