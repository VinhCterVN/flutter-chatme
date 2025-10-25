import 'dart:developer';

import 'package:chatme/ui/screens/auth/register.dart';
import 'package:chatme/ui/screens/auth/welcome.dart';
import 'package:chatme/ui/screens/home.dart';
import 'package:chatme/ui/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/auth_provider.dart';
import '../ui/layout/app_layout.dart';
import '../ui/screens/auth/login.dart';
import '../ui/screens/chat.dart';
import '../ui/screens/contacts.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/login',
    navigatorKey: GlobalKey<NavigatorState>(),
    redirect: (context, state) {
      final user = ref.watch(currentUserProvider);
      final path = state.uri.path;

      log("User: $user");

      final isAuthRoute = path == '/login' || path == '/register';
      if (user == null) {
        return isAuthRoute ? null : '/login';
      } else {
        if (user.displayName == null) return '/welcome';
        return isAuthRoute ? '/home' : null;
        // return isAuthRoute ? '/chat/:hwo' : null;
      }
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', name: 'HomePage', builder: (context, state) => const HomePage())],
          ),

          StatefulShellBranch(
            routes: [GoRoute(path: '/contacts', name: 'ContactsPage', builder: (context, state) => ContactsPage())],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(path: '/settings', name: 'SettingsPage', builder: (context, state) => const SettingsPage()),
            ],
          ),
        ],
      ),

      GoRoute(
          name: 'ChatDetails',
          path: '/chat/:type/:roomId/:title',
          pageBuilder: (context, state) =>
              CustomTransitionPage(
                  key: state.pageKey,
                  opaque: false,
                  barrierColor: Colors.transparent,
                  child: ChatDetails(
                    type: state.pathParameters['type']!,
                    roomId: state.pathParameters['roomId']!,
                    title: state.pathParameters['title']!,
                  ),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (context, animation, secondAnimation, child) {
                    final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).chain(
                        CurveTween(curve: Curves.easeOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  }
              )
      ),
      GoRoute(name: 'LoginPage', path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(name: 'RegisterPage', path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(name: 'WelcomePage', path: '/welcome', builder: (_, _) => WelcomePage()),
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    ],
  );
}
