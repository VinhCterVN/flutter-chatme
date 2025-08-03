import 'package:chatme/helper/snack_bar.dart';
import 'package:chatme/provider/riverpod_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome ${user?.displayName ?? "Unnamed"}!'),
          Lottie.asset(
            "assets/animations/impress.json",
            repeat: false,
            width: 600,
          ),
          ElevatedButton(
            onPressed: () {
              showAppSnackBar(context: context, message: GoRouterState.of(context).uri.toString());
            },
            child: const Text('Start Chatting'),
          ),
        ],
      ),
    );
  }
}
