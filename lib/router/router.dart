import 'package:chatme/ui/screens/auth/register.dart';
import 'package:chatme/ui/screens/auth/welcome.dart';
import 'package:chatme/ui/screens/home.dart';
import 'package:chatme/ui/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/riverpod_providers.dart';
import '../ui/layout/app_layout.dart';
import '../ui/screens/auth/login.dart';
import '../ui/screens/chat.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = ref.watch(currentUserProvider);
      final path = state.uri.path;

      // log("User: $user");

      final isAuthRoute = path == '/login' || path == '/register';

      if (user == null) {
        return isAuthRoute ? null : '/login';
      } else {
        if (user.displayName == null) return '/welcome';
        return isAuthRoute ? '/home' : null;
      }
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          GoRoute(name: 'HomePage', path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(name: 'ChatPage', path: '/chat', builder: (context, state) => const ChatPage()),
          GoRoute(name: 'SettingsPage', path: '/settings', builder: (context, state) => const SettingsPage()),
        ],
      ),
      GoRoute(name: 'LoginPage', path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(name: 'RegisterPage', path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(name: 'WelcomePage', path: '/welcome', builder: (_, _) => WelcomePage()),
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Center(child: CircularProgressIndicator())),
        // builder: (_, _) => const WelcomePage(),
      ),
    ],
  );
}
