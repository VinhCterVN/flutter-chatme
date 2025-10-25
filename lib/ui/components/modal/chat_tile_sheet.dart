import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/snack_bar.dart';

class ChatTileSheet extends ConsumerStatefulWidget {
  const ChatTileSheet({super.key});

  @override
  ConsumerState<ChatTileSheet> createState() => _ChatTileSheetState();
}

class _ChatTileSheetState extends ConsumerState<ChatTileSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('View Profile'),
          onTap: () {
            Navigator.pop(context);
            showAppSnackBar(context: context, message: "View Profile tapped", duration: const Duration(seconds: 1));
          },
        ),
        ListTile(
          leading: const Icon(Icons.message_outlined),
          title: const Text('Send Message'),
          onTap: () {
            Navigator.pop(context);
            showAppSnackBar(context: context, message: "Send Message tapped", duration: const Duration(seconds: 1));
          },
        ),
      ],
    );
  }
}
