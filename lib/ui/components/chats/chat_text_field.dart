import 'dart:math';

import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const ChatTextField({super.key, required this.controller, required this.focusNode});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final _hints = const [
    "Aa",
    "Type a message...",
    "What's on your mind?",
    "Share your thoughts...",
    "Send a message...",
    "Write something...",
    "Type here...",
    "What happened today?",
  ];
  late final String _hint;

  @override
  void initState() {
    super.initState();
    _hint = _hints[Random().nextInt(_hints.length)];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: (isDarkTheme
              ? Theme.of(context).colorScheme.surfaceBright
              : Theme.of(context).colorScheme.surfaceDim.withAlpha(100)),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
          ),
          onChanged: (_) => (context as Element).markNeedsBuild(),
          decoration: InputDecoration(
            isDense: true,
            hintText: _hint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          minLines: 1,
          maxLines: 5,
        ),
      ),
    );
  }
}
