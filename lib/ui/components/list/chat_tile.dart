import 'dart:math';

import 'package:chatme/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/chat_model.dart';
import '../../../data/model/ui_state.dart';
import '../../../helper/formatter.dart';
import '../../../helper/snack_bar.dart';
import '../../../provider/user_provider.dart';
import '../../../service/chat_service.dart';

class ChatTile extends ConsumerStatefulWidget {
  final Chat chat;
  final int? index;

  const ChatTile({super.key, required this.chat, this.index});

  @override
  ConsumerState<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends ConsumerState<ChatTile> {
  UIState _uiState = UIState.loading;

  @override
  void initState() {
    // _fetchChatData();
    super.initState();
  }

  Future<void> _fetchChatData() async {
    final userService = ref.read(userServiceProvider);
    final users = await userService.getUsersByIds(widget.chat.participants);
    widget.chat.groupMembers = users
        .map((user) => ChatMember(userId: user.uid, displayName: user.displayName, photoUrl: user.photoUrl))
        .toList();
    setState(() => _uiState = UIState.ready);
  }

  String _getGroupName() {
    final user = ref.read(currentUserProvider)?.uid;
    if (widget.chat.type == ChatType.group) return widget.chat.groupName ?? widget.chat.groupMembers?.join(', ') ?? 'Group Chat';
    return widget.chat.groupMembers?.firstWhere((e) => e.userId != user).displayName ?? 'Private Chat';
  }

  @override
  Widget build(BuildContext context) {
    final isGroup = widget.chat.type == ChatType.group;
    final lastMsg = widget.chat.lastMsg ?? "No messages yet";
    final lastMsgTime = widget.chat.lastMsgTime != null ? formatChatTime(widget.chat.lastMsgTime!) : '';
    return ListTile(
      onTap: () async {
        if (!context.mounted) return;
        context.pushNamed('ChatDetails', pathParameters: {'type': widget.chat.type.name, 'roomId': widget.chat.id});
      },
      onLongPress: () async {
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          showDragHandle: true,
          barrierColor: Colors.black54,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
          widget.chat.groupAvatarUrl ?? "https://i.pravatar.cc/200/img=${widget.index ?? Random().nextInt(100)}",
        ),
        radius: 25,
      ),
      title: Text(
        widget.chat.groupName!,
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
