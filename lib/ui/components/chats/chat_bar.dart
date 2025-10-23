import 'package:chatme/ui/components/chats/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatBar extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onSendMessage;

  const ChatBar({super.key, required this.onSendMessage, required this.controller, required this.focusNode});

  @override
  ConsumerState<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends ConsumerState<ChatBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.image_outlined, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Expanded(child: ChatTextField(controller: widget.controller, focusNode: widget.focusNode)),
          IconButton(
            onPressed: () {
              if (widget.controller.text.isNotEmpty) {
                widget.onSendMessage();
                widget.controller.clear();
              }
            },
            icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
