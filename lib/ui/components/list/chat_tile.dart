import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/ui/components/modal/chat_tile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/chat_model.dart';
import '../../../helper/formatter.dart';
import '../../../service/chat_service.dart';

class ChatTile extends ConsumerStatefulWidget {
  final Chat chat;
  final int? index;

  const ChatTile({super.key, required this.chat, this.index});

  @override
  ConsumerState<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends ConsumerState<ChatTile> {
  @override
  Widget build(BuildContext context) {
    final isGroup = widget.chat.type == ChatType.group;
    final lastMsg = widget.chat.lastMsg ?? "No messages yet";
    final lastMsgTime = widget.chat.lastMsgTime != null ? formatChatTime(widget.chat.lastMsgTime!) : '';
    return ListTile(
      onTap: () async {
        if (!context.mounted) return;
        context.pushNamed(
          'ChatDetails',
          pathParameters: {
            'type': widget.chat.type.name,
            'roomId': widget.chat.id,
            'title': widget.chat.groupName ?? 'Chat',
          },
        );
      },
      onLongPress: () async => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        showDragHandle: true,
        barrierColor: Colors.black54,
        builder: (context) => const ChatTileSheet()
      ),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          widget.chat.groupAvatarUrl ?? "https://i.pravatar.cc/200/img=${widget.index ?? Random().nextInt(100)}",
        ),
        radius: 25,
      ),
      title: Text(widget.chat.groupName!, style: const TextStyle(fontWeight: FontWeight.w600)),
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
