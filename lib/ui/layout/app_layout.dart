import 'dart:ui';

import 'package:chatme/ui/components/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/auth_provider.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  final routes = [
    {"name": "Home", "path": "/home", "icon": Icons.home_outlined, "active_icon": Icons.home},
    {"name": "Contacts", "path": "/contacts", "icon": Icons.contacts_outlined, "active_icon": Icons.contacts},
    {"name": "Settings", "path": "/settings", "icon": Icons.settings_outlined, "active_icon": Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authenticationServiceProvider);
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentRouteName = GoRouterState.of(context).name;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: AppLabel(label: currentRouteName ?? "chatme...", fontSize: 36, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () async {
              await authService.sendVerificationEmail();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onSurface),
            onPressed: authService.signOut,
          ),
        ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Theme.of(context).colorScheme.surface.withAlpha((250 * 65 / 100).toInt())),
            ),
          ),
        bottomOpacity: 0.0,
      ),
      extendBodyBehindAppBar: currentLocation != '/home',
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
      body: widget.child,
    );
  }
}
