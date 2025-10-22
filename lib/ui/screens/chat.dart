import 'dart:developer';
import 'dart:ui';

import 'package:chatme/helper/snack_bar.dart';
import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/ui/components/chat_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/chat_provider.dart';

class ChatDetails extends ConsumerStatefulWidget {
  final String? type;
  final String? chatId;
  final ScrollController scrollController = ScrollController();
  final List<String> messages = const [
    "Hello, how are you?",
    "I'm fine, thanks! And you?",
    "Doing great, just working on a project.",
    "That sounds interesting! What kind of project?",
    "It's a chat application using Flutter and Firebase.",
    "Wow, that sounds awesome! I love Flutter!",
    "Me too! It's so flexible and powerful.",
    "Absolutely! Have you tried using Riverpod for state management?",
    "Yes, I have. It's really great for managing state in Flutter apps.",
    "Hello, how are you?",
    "I'm fine, thanks! And you?",
    "Doing great, just working on a project.",
    "That sounds interesting! What kind of project?",
    "It's a chat application using Flutter and Firebase.",
    "Wow, that sounds awesome! I love Flutter!",
    "Me too! It's so flexible and powerful.",
    "Absolutely! Have you tried using Riverpod for state management?",
    "Yes, I have. It's really great for managing state in Flutter apps.",
    "Hello, how are you?",
    "I'm fine, thanks! And you?",
    "Doing great, just working on a project.",
    "That sounds interesting! What kind of project?",
    "It's a chat application using Flutter and Firebase.",
    "Wow, that sounds awesome! I love Flutter!",
    "Me too! It's so flexible and powerful.",
    "Absolutely! Have you tried using Riverpod for state management?",
    "Yes, I have. It's really great for managing state in Flutter apps.",
    "Hello, how are you?",
    "I'm fine, thanks! And you?",
    "Doing great, just working on a project.",
    "That sounds interesting! What kind of project?",
    "It's a chat application using Flutter and Firebase.",
    "Wow, that sounds awesome! I love Flutter!",
    "Me too! It's so flexible and powerful.",
    "Absolutely! Have you tried using Riverpod for state management?",
    "Yes, I have. It's really great for managing state in Flutter apps.",
  ];

  ChatDetails({super.key, required this.type, this.chatId});

  @override
  ConsumerState<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends ConsumerState<ChatDetails> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          log("Chat input focused");
        } else {
          log("Chat input unfocused");
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    log("Chat disposed");
    _controller.dispose();
    _focusNode.dispose();
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchChatData(ref.watch(currentUserProvider)?.uid ?? "");

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
            onTap: () {},
            leading: CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.png') as ImageProvider),
            title: Text("Opponent ", style: TextStyle(fontWeight: FontWeight.bold)),
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
            IconButton(icon: const Icon(Icons.call), onPressed: () {}),
            Builder(
              builder: (context) =>
                  IconButton(icon: const Icon(Icons.more_vert), onPressed: () => Scaffold.of(context).openEndDrawer()),
            ),
          ],
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Theme.of(context).colorScheme.surface.withAlpha((250 * 65 / 100).toInt())),
            ),
          ),
          bottomOpacity: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    // TODO: Improve alignment logic for better UX
                    alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onDoubleTap: () {
                        showAppSnackBar(
                          context: context,
                          message: "Message tapped: ${widget.messages[index]}",
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.messages[index],
                          style: TextStyle(
                            color: index % 2 == 0
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                    showAppSnackBar(
                      context: context,
                      message: "Message sent: ${_controller.text}",
                      duration: const Duration(seconds: 2),
                    );
                    _controller.clear();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchChatData(String hostId) async {
    final data = switch (widget.type) {
      "group" => await ref.read(chatServiceProvider).getGroupChat(widget.chatId!),
      "private" => await ref.read(chatServiceProvider).getPrivateChat(widget.chatId!, hostId),
      _ => "Data error?",
    };

    log("Chat data fetched: $data");
  }
}
