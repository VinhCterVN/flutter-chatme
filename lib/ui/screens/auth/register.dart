import 'dart:math';

import 'package:chatme/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../helper/snack_bar.dart';
import '../../components/app_label.dart';
import '../../components/common_button.dart';
import '../../components/my_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  final TextEditingController _pswConfirmController = TextEditingController();
  bool _isLoading = false;
  bool _emailValidated = false;

  void toggleLoading() => setState(() {
    _isLoading = !_isLoading;
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final authService = ref.watch(authenticationServiceProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true, // important
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(isDarkTheme ? 100 : 150),
              Color(0xFF8573f1).withAlpha(isDarkTheme ? 100 : 150),
              // Theme.of(context).colorScheme.tertiary.withAlpha(100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/images/chatme.svg",
                            width: min(MediaQuery.of(context).size.width * 0.75, 250),
                          ),
                          const AppLabel(label: "Register"),

                          const SizedBox(height: 50),
                          MyTextField(
                            hintText: "Enter your email",
                            inputType: MyInputType.email,
                            controller: _mailController,
                            enabled: !_emailValidated,
                            // Focus on psw TF
                            onConfirm: (value) {
                              if (_mailController.text.isNotEmpty) {
                                setState(() {
                                  _emailValidated = true;
                                });
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.2),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _emailValidated
                                ? Column(
                                    key: const ValueKey("passwordField"),
                                    children: [
                                      const SizedBox(height: 18),
                                      MyTextField(
                                        hintText: "Enter your password",
                                        inputType: MyInputType.password,
                                        controller: _pswController,
                                      ),
                                      const SizedBox(height: 18),
                                      MyTextField(
                                        hintText: "Repeat your password",
                                        inputType: MyInputType.password,
                                        controller: _pswConfirmController,
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(key: ValueKey("empty")),
                          ),

                          Row(
                            mainAxisAlignment: _emailValidated ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_emailValidated)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _emailValidated = !_emailValidated;
                                    });

                                    _pswController.clear();
                                    _pswConfirmController.clear();
                                  },
                                  icon: Icon(Icons.chevron_left),
                                ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          CommonButton(
                            label: _isLoading ? "Registering..." : "Register Account",
                            onPressed: () async {
                              if (_mailController.text.isEmpty) {
                                showAppSnackBar(context: context, message: "Please enter your email address.");
                                return;
                              }

                              if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(_mailController.text)) {
                                showAppSnackBar(context: context, message: "Please enter a valid email address.");
                                return;
                              }

                              if (!_emailValidated) {
                                setState(() {
                                  _emailValidated = true;
                                });
                                FocusScope.of(context).nextFocus();
                                return;
                              }

                              if (_pswController.text.isEmpty) {
                                showAppSnackBar(context: context, message: "Please enter your password.");
                                return;
                              }

                              if (_pswController.text != _pswConfirmController.text) {
                                showAppSnackBar(context: context, message: "Passwords do not match.");
                                return;
                              }

                              try {
                                toggleLoading();
                                String? result = await authService.signUp(
                                  email: _mailController.text,
                                  password: _pswController.text,
                                );

                                if (result == null || !context.mounted) return;
                                showAppSnackBar(context: context, message: result);
                              } catch (e) {
                                showAppSnackBar(context: context, message: e.toString());
                              } finally {
                                toggleLoading();
                              }
                            },
                          ),

                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () async {
                                  context.go("/login");
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateColor.transparent,
                                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0)),
                                ),
                                child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
