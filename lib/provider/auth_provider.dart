
import 'package:chatme/service/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider for AuthenticationService
final authenticationServiceProvider = Provider<AuthenticationService>((ref) => AuthenticationService(FirebaseAuth.instance));

/// Provider for LogIn State
final authStateProvider = StreamProvider<User?>((ref) => ref.watch(authenticationServiceProvider).authStateChanges);

/// Provider for Current User
final currentUserProvider = StateProvider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});