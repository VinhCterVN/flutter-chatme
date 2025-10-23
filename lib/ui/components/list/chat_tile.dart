import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/chat_model.dart';
import '../../../helper/formatter.dart';
import '../../../helper/snack_bar.dart';
import '../../../service/chat_service.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;
  final int? index;

  const ChatTile({super.key, required this.chat, this.index});

  @override
  Widget build(BuildContext context) {
    final isGroup = chat.type == ChatType.group;
    final lastMsg = chat.lastMsg ?? "No messages yet";
    final lastMsgTime = chat.lastMsgTime != null ? formatChatTime(chat.lastMsgTime!) : '';
    return ListTile(
      onTap: () async {
        if (!context.mounted) return;
        context.pushNamed('ChatDetails', pathParameters: {'type': chat.type.name, 'roomId': chat.id});
      },
      onLongPress: () async {
        showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('View Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      showAppSnackBar(
                        context: context,
                        message: "View Profile tapped",
                        duration: const Duration(seconds: 1),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.message_outlined),
                    title: const Text('Send Message'),
                    onTap: () {
                      Navigator.pop(context);
                      showAppSnackBar(
                        context: context,
                        message: "Send Message tapped",
                        duration: const Duration(seconds: 1),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          chat.groupAvatarUrl ?? "https://i.pravatar.cc/${index ?? Random().nextInt(1000)}",
        ),
        radius: 25,
      ),
      title: Text(
        chat.groupName ?? (isGroup ? "Group Chat" : "Private Chat"),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        lastMsg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        lastMsgTime,
        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(150)),
      ),
    );
  }
}
