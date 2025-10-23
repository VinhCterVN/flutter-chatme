import 'dart:ui';

import 'package:chatme/ui/components/app_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/auth_provider.dart';
import '../components/app_drawer.dart';

class AppLayout extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppLayout({super.key, required this.navigationShell});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  final routes = [
    {"name": "Home", "icon": Icons.home_outlined, "active_icon": Icons.home},
    {"name": "Contacts", "icon": Icons.contacts_outlined, "active_icon": Icons.contacts},
    {"name": "Settings", "icon": Icons.settings_outlined, "active_icon": Icons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authenticationServiceProvider);
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: AppLabel(
          label: routes[currentIndex]['name'] as String,
          fontSize: 36,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
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
      ),
      endDrawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      extendBodyBehindAppBar: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: currentIndex,
        onTap: (int index) {
          widget.navigationShell.goBranch(index, initialLocation: false);
        },
        items: routes.map((route) {
          return BottomNavigationBarItem(
            icon: Icon(route['icon'] as IconData),
            activeIcon: Icon(route['active_icon'] as IconData),
            label: route['name'] as String,
          );
        }).toList(),
      ),
    );
  }
}
