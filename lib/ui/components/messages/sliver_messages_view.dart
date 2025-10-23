import 'dart:async';

import 'package:chatme/data/model/chat_model.dart';
import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../data/model/ui_state.dart';

class SliverMessagesView extends ConsumerStatefulWidget {
  final String roomId;
  final List<ChatMember> _members;

  const SliverMessagesView({super.key, required this.roomId, required List<ChatMember> members}) : _members = members;

  @override
  ConsumerState<SliverMessagesView> createState() => _SliverMessagesViewState();
}

class _SliverMessagesViewState extends ConsumerState<SliverMessagesView> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  List<ChatMessage> _messages = [];
  UIState _uiState = UIState.Loading;
  StreamSubscription<List<ChatMessage>>? _sub;

  @override
  void initState() {
    super.initState();
    final chatService = ref.read(chatServiceProvider);

    _sub = chatService.streamMessages(widget.roomId).listen((newMsgs) {
      if (newMsgs.length > _messages.length) {
        final diff = newMsgs.length - _messages.length;
        setState(() => _messages = newMsgs);
        for (int i = 0; i < diff; i++) {
          _listKey.currentState?.insertItem(0);
        }
      } else {
        setState(() => _messages = newMsgs);
      }
    });
    Future.delayed(const Duration(seconds: 2), () => setState(() => _uiState = UIState.Ready)
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return switch (_uiState) {
      UIState.Loading => const Center(child: CircularProgressIndicator()),
      UIState.Error => const Text('Error loading messages.'),
      UIState.Ready => CustomScrollView(
        reverse: true,
        slivers: [
          if (_messages.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/impress.json', repeat: false),
                  Text('No messages yet. Start the conversation!', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          else ...[
            SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverAnimatedList(
              key: _listKey,
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
                      child: Container(
                        margin: const EdgeInsets.all(6),
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
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 80)),
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: ClipOval(child: Image.asset('assets/images/avatar.png', fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget._members.where((m) => m.userId != currentUser!.uid).map((m) => m.displayName).join(', '),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    };
  }
}
