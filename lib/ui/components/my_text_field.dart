import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final Function? onConfirm;
  final String? hintText;
  final MyInputType? inputType;
  final bool? enabled;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    this.onConfirm,
    this.hintText,
    this.enabled,
    required this.controller,
    this.inputType = MyInputType.text,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final FocusNode _focusNode = FocusNode();
  bool isObscured = true;

  void _toggleObscureText() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  dynamic _getInputTypeData() {
    return switch (widget.inputType) {
      MyInputType.text      => {"icon": Icons.text_fields, "keyboardType": TextInputType.text, "obscureText": false},
      MyInputType.name      => {"icon": Icons.drive_file_rename_outline, "keyboardType": TextInputType.text, "obscureText": false},
      MyInputType.password  => {"icon": Icons.lock, "keyboardType": TextInputType.visiblePassword, "obscureText": true},
      MyInputType.email     => {"icon": Icons.email, "keyboardType": TextInputType.emailAddress, "obscureText": false},
      MyInputType.number    => {"icon": Icons.numbers, "keyboardType": TextInputType.number, "obscureText": false},
      _                     => {"icon": Icons.text_fields, "keyboardType": TextInputType.text, "obscureText": false},
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final inputTypeData = _getInputTypeData();
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(_focusNode.hasFocus ? 150 : 100),
                width: _focusNode.hasFocus ? 1.2 : 1,
              ),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8)],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: TextStyle(
                color: isDarkTheme ? Colors.white70 : Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: isDarkTheme ? Colors.white38 : Colors.black38,
              decoration: InputDecoration(
                hintText: widget.hintText ?? "Enter text",
                hintStyle: TextStyle(color: isDarkTheme ? Colors.white38 : Colors.black38),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                icon: Icon(
                  inputTypeData["icon"],
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(_focusNode.hasFocus ? 150 : 100),
                ),
                suffixIcon: switch (widget.inputType) {
                  MyInputType.password => IconButton(
                    icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                    onPressed: _toggleObscureText,
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(_focusNode.hasFocus ? 150 : 100),
                  ),
                  MyInputType.email =>
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(widget.controller.text)
                        ? Icon(
                            Icons.check,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer.withAlpha(_focusNode.hasFocus ? 150 : 100),
                          )
                        : Icon(
                            Icons.error_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withAlpha(150),
                          ),
                  _ => null,
                },
              ),
              keyboardType: inputTypeData["keyboardType"],
              inputFormatters: [
                if (widget.inputType == MyInputType.number) FilteringTextInputFormatter.digitsOnly,
                if (widget.inputType == MyInputType.email)
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
              ],
              obscureText: widget.inputType == MyInputType.password ? isObscured : inputTypeData["obscureText"],
              enabled: widget.enabled ?? true,
              onSubmitted: (value) {
                if (widget.onConfirm != null) {
                  widget.onConfirm!(value);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum MyInputType { text, password, email, number, name }
