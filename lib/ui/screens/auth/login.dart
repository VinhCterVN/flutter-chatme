import 'dart:math';

import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/ui/components/app_label.dart';
import 'package:chatme/ui/components/common_button.dart';
import 'package:chatme/ui/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../helper/snack_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  bool _isLoading = false;

  void _toggleLoading() => setState(() {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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
                          const AppLabel(),

                          const SizedBox(height: 50),

                          MyTextField(
                            hintText: "Enter your email",
                            inputType: MyInputType.email,
                            controller: _mailController,
                          ),
                          const SizedBox(height: 18),

                          MyTextField(
                            hintText: "Enter your password",
                            inputType: MyInputType.password,
                            controller: _pswController,
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),

                          const SizedBox(height: 40),

                          CommonButton(
                            label: _isLoading ? "Logging...." : "Login",
                            onPressed: () async {
                              if (_isLoading) return null;

                              try {
                                _toggleLoading();
                                if (_mailController.text.isEmpty || _pswController.text.isEmpty) {
                                  showAppSnackBar(context: context, message: "Please fill in all fields.");
                                  return;
                                }

                                String? result = await authService.signIn(
                                  email: _mailController.text,
                                  password: _pswController.text,
                                );

                                if (result != null && mounted) showAppSnackBar(context: context, message: result, action: SnackBarAction(label: "Hide", onPressed: () {}));
                              } finally {
                                _toggleLoading();
                              }
                            },
                          ),

                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text("Do not have an account? "),
                              TextButton(
                                onPressed: () async {
                                  context.go("/register");
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateColor.transparent,
                                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 4)),
                                ),
                                child: const Text("Create account", style: TextStyle(fontWeight: FontWeight.w700)),
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
