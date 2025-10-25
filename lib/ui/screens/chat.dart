import 'dart:ui';

import 'package:chatme/data/model/ui_state.dart';
import 'package:chatme/provider/chat_provider.dart';
import 'package:chatme/provider/user_provider.dart';
import 'package:chatme/ui/components/messages/sliver_messages_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/chat_model.dart';
import '../../provider/auth_provider.dart';
import '../components/chats/chat_bar.dart';

class ChatDetails extends ConsumerStatefulWidget {
  final String roomId;
  final String title;
  final String type;
  final ScrollController scrollController = ScrollController();

  ChatDetails({super.key, required this.type, required this.roomId, required this.title});

  @override
  ConsumerState<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends ConsumerState<ChatDetails> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Chat? _chat;
  UIState _uiState = UIState.loading;
  double _translateX = 0.0;
  Offset? _startOffset;

  @override
  void initState() {
    super.initState();
    fetchChatData(ref);
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  Future<void> fetchChatData(WidgetRef ref) async {
    final chatService = ref.read(chatServiceProvider);
    final userService = ref.read(userServiceProvider);
    final res = await chatService.fetchRoomData(widget.roomId);

    if (res is Chat) {
      final users = await userService.getUsersByIds(res.participants);
      setState(() {
        _chat = res;
        _chat?.groupMembers = users
            .map((e) => (ChatMember(userId: e.uid, displayName: e.displayName, photoUrl: e.photoUrl)))
            .toList();
        _uiState = UIState.ready;
      });
    } else {
      setState(() => _uiState = UIState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final chatService = ref.read(chatServiceProvider);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onHorizontalDragStart: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < screenWidth * 0.25) {
          _startOffset = details.globalPosition;
        } else {
          _startOffset = null;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (_startOffset == null) return;
        final delta = details.globalPosition.dx - _startOffset!.dx;
        if (delta > 0) {
          setState(() => _translateX = delta.clamp(0, 200));
        }
      },
      onHorizontalDragEnd: (_) {
        if (_translateX > 100) {
          context.pop();
          return;
        }
        setState(() => _translateX = 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(_translateX, 0, 0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width,
            backgroundColor: isDarkTheme ? Colors.black : Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO: Implement drawer content
                  Text("Drawer content goes here"),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            titleSpacing: 0,
            title: ListTile(
              onTap: () async {
                Scaffold.of(context).openEndDrawer();
              },
              leading: CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.png') as ImageProvider),
              title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                "Last seen: ${DateTime.now().subtract(const Duration(minutes: 5)).toLocal().hour}",
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              contentPadding: EdgeInsetsDirectional.zero,
            ),
            leading: IconButton(onPressed: context.pop, icon: const Icon(Icons.arrow_back)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(icon: const Icon(Icons.call), onPressed: () {}, tooltip: "Start a voice call"),
              IconButton(
                icon: const Icon(Icons.emergency_recording_rounded),
                onPressed: () {},
                tooltip: "Start a video call",
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: "More options",
                ),
              ),
            ],
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Theme.of(context).colorScheme.surface.withAlpha((250 * 65 / 100).toInt())),
              ),
            ),
            bottom: (_uiState == UIState.loading)
                ? PreferredSize(
                    preferredSize: Size.fromHeight(4.0),
                    child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadiusGeometry.circular(4.0),
                    ),
                  )
                : null,
            bottomOpacity: _uiState == UIState.loading ? 1.0 : 0.0,
          ),
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              Expanded(
                child: SliverMessagesView(
                  roomId: widget.roomId,
                  members: _chat?.groupMembers ?? [],
                  scrollController: widget.scrollController,
                ),
              ),
              SafeArea(
                top: false,
                child: AnimatedPadding(
                  duration: const Duration(microseconds: 150),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.zero,
                  child: ChatBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSendMessage: () {
                      if (_controller.text.trim().isEmpty) return;
                      chatService.sendMessage(widget.roomId, currentUser!.uid, _controller.text.trim());
                      _controller.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
