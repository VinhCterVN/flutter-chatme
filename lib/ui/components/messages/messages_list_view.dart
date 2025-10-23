import 'dart:async';

import 'package:chatme/data/model/chat_model.dart';
import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/snack_bar.dart';

class MessagesListView extends ConsumerStatefulWidget {
  final String roomId;
  final ScrollController scrollController;

  const MessagesListView({super.key, required this.roomId, required this.scrollController});

  @override
  ConsumerState<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends ConsumerState<MessagesListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<ChatMessage> _messages = [];
  StreamSubscription<List<ChatMessage>>? _messageSub;

  @override
  void initState() {
    super.initState();
    final chatService = ref.read(chatServiceProvider);
    _messageSub = chatService.streamMessages(widget.roomId).listen(_onMessagesUpdated);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    super.dispose();
    _messageSub?.cancel();
  }

  void _onMessagesUpdated(List<ChatMessage> newMessages) {
    if (newMessages.length > _messages.length) {
      setState(() {
        _messages = newMessages;
      });
      _listKey.currentState?.insertItem(0);
    } else {
      setState(() {
        _messages = newMessages;
      });
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserProvider);

    if (_messages.isEmpty) {
      return const Center(child: Text("No messages yet. Start the conversation!"));
    }

    return AnimatedList(
      key: _listKey,
      controller: widget.scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      initialItemCount: _messages.length,
      itemBuilder: (context, index, animation) {
        final msg = _messages[index];
        final isMine = msg.senderId == currentUser!.uid;

        return SizeTransition(
          sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: animation,
            child: Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onDoubleTap: () {
                  showAppSnackBar(context: context, message: "Message tapped", duration: const Duration(seconds: 2));
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: !isMine
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg.content,
                    style: TextStyle(
                      color: !isMine
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
