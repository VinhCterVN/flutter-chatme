// Helper function to determine slide direction based on route order
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Offset _getSlideOffset(String fromPath, String toPath) {
  // Define a simple route order for demonstration (home -> chat -> settings)
  const routeOrder = ['/home', '/chat', '/settings'];
  final fromIndex = routeOrder.indexOf(fromPath);
  final toIndex = routeOrder.indexOf(toPath);

  return fromIndex <= toIndex ? const Offset(1, 0) : const Offset(-1, 0);
}

// Custom page builder for slide transitions
CustomTransitionPage<T> slidePage<T>(
  GoRouterState state,
  Widget child, {
  Duration duration = const Duration(milliseconds: 300),
}) {
  // Get the 'from' path from state.extra or fallback to current path
  final fromPath = (state.extra as Map<String, String>?)?['from'] ?? state.fullPath;
  final toPath = state.fullPath;

  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final beginOffset = _getSlideOffset(fromPath!, toPath!);
      return SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}
