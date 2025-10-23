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
  late final ScrollController _scrollController;
  List<ChatMessage> _messages = [];
  UIState _uiState = UIState.loading;
  StreamSubscription<List<ChatMessage>>? _sub;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
    Future.delayed(const Duration(seconds: 1), () => setState(() => _uiState = UIState.ready));
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isFirstInGroup(int index) {
    if (index == _messages.length - 1) return true;

    final current = _messages[index];
    final next = _messages[index + 1];

    final currentTime = current.timestamp.toDate();
    final nextTime = next.timestamp.toDate();

    return current.senderId != next.senderId || currentTime.difference(nextTime).inMinutes > 5;
  }

  bool _isLastInGroup(int index) {
    if (index == 0) return true;

    final current = _messages[index];
    final prev = _messages[index - 1];

    final currentTime = current.timestamp.toDate();
    final prevTime = prev.timestamp.toDate();

    return current.senderId != prev.senderId || prevTime.difference(currentTime).inMinutes > 5;
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    final isToday = now.day == time.day && now.month == time.month && now.year == time.year;
    final isYesterday =
        now.subtract(const Duration(days: 1)).day == time.day &&
        now.subtract(const Duration(days: 1)).month == time.month &&
        now.subtract(const Duration(days: 1)).year == time.year;
    final isThisYear = now.year == time.year;

    if (isToday) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else if (isYesterday) {
      return "Yesterday, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays < 7) {
      const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
      final weekday = weekdays[time.weekday % 7];
      return "$weekday, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else if (isThisYear) {
      return "${time.day}/${time.month}, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      return "${time.day}/${time.month}/${time.year}, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return switch (_uiState) {
      UIState.loading => const Center(child: CircularProgressIndicator()),
      UIState.error => const Text('Error loading messages.'),
      UIState.ready => CustomScrollView(
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
                final first = _isFirstInGroup(index);
                final last = _isLastInGroup(index);

                return SizeTransition(
                  sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                  axisAlignment: -1.0,
                  child: FadeTransition(
                    opacity: animation,
                    child: Column(
                      crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (first) const SizedBox(height: 8),

                        Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 6, right: 6, top: first ? 2 : 1, bottom: last ? 4 : 1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? Theme.of(context).colorScheme.secondaryContainer
                                  : Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isMine ? 18 : (first ? 18 : 6)),
                                topRight: Radius.circular(isMine ? (first ? 18 : 6) : 18),
                                bottomLeft: Radius.circular(isMine ? 18 : (last ? 18 : 6)),
                                bottomRight: Radius.circular(isMine ? (last ? 18 : 6) : 18),
                              ),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Text(
                              msg.content,
                              textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: isMine
                                    ? Theme.of(context).colorScheme.onSecondaryContainer
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),

                        if (last && index != 0)
                          Align(
                            alignment: AlignmentGeometry.center,
                            child: Text(
                              _formatMessageTime(msg.timestamp.toDate()),
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100),
                              ),
                            ),
                          ),
                      ],
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
            SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    };
  }
}
