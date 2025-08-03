import 'package:chatme/ui/components/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/riverpod_providers.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  final routes = [
    {"name": "Home", "path": "/home", "icon": Icons.home_outlined, "active_icon": Icons.home},
    {"name": "Chat", "path": "/chat", "icon": Icons.message_outlined, "active_icon": Icons.message},
    {"name": "Settings", "path": "/settings", "icon": Icons.settings_outlined, "active_icon": Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authenticationServiceProvider);
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: AppLabel(label: "chatme...", fontSize: 36, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              // Handle notification action
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              authService.signOut();
            },
          ),
        ],
      ),
      body: widget.child,
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: routes.indexWhere((route) => route['path'] == currentLocation),
        onTap: (int index) {
          final route = routes[index];
          context.go(route['path'] as String);
        },
        items: routes.map((route) {
          return BottomNavigationBarItem(
            key: Key(route['path'] as String),
            icon: Icon(route['icon'] as IconData),
            activeIcon: Icon(route['active_icon'] as IconData),
            label: route['name'] as String,
            tooltip: route['name'] as String,
          );
        }).toList(),
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        enableFeedback: false,
      ),
    );
  }
}
