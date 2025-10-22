import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/ui/components/common_button.dart';
import 'package:chatme/ui/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadex/shadex.dart';

import '../../../helper/snack_bar.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation1;
  late Animation<Offset> _animation2;
  bool _showText = false;
  bool _showField = false;
  bool _showBtn = false;
  bool _isLoading = false;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation1 = Tween<Offset>(
      begin: Offset(-1.5, -1.5),
      end: Offset(-0.0725, -0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animation2 = Tween<Offset>(
      begin: Offset(1.5, 1.5),
      end: Offset(0.0725, 0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      setState(() {
        _showText = true;
      });
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() {
          _showField = true;
        }),
      );
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() {
          _showBtn = true;
        }),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLoading() => setState(() {
    _isLoading = !_isLoading;
  });

  @override
  Widget build(BuildContext context) {
    final verticalPadding = 24.0;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final titles = [
      "Welcome to Chat Me!",
      "Let's get started",
      "What should we call you?",
      "What's your name?",
      "We are glad to have you here!",
    ];
    final images = ["assets/images/clarity--chat-bubble-solid.svg", "assets/images/fluent-color--chat-48.svg"];

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          verticalPadding * 2,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(flex: 2),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ...[_animation2, _animation1].map(
                                (animation) => SlideTransition(
                                  position: animation,
                                  child: Shadex(
                                    shadowColor: Colors.black38.withAlpha(50),
                                    shadowBlurRadius: 12.0,
                                    shadowOffset: Offset(8, 8),
                                    child: SvgPicture.asset(images[_animation2 == animation ? 0 : 1], width: 250),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedOpacity(
                            opacity: _showText ? 1.0 : 0.0,
                            duration: Duration(microseconds: 1000),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      titles[(titles.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)
                                              .floor() %
                                          titles.length],
                                      textStyle: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Klavika",
                                      ),
                                      textAlign: TextAlign.center,
                                      speed: Duration(milliseconds: 200),
                                    ),
                                  ],
                                  totalRepeatCount: 1,
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),

                          AnimatedOpacity(
                            opacity: _showField ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: MyTextField(
                              controller: _textController,
                              inputType: MyInputType.name,
                              hintText: "What should we call you?",
                            ),
                          ),

                          Spacer(flex: 4),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final authState = ref.watch(authenticationServiceProvider);
                                  authState.signOut();
                                },
                                icon: Icon(Icons.chevron_left),
                              ),
                            ],
                          ),

                          AnimatedOpacity(
                            opacity: _showBtn ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: CommonButton(
                              label: "Get Started",
                              onPressed: _textController.text.isNotEmpty
                                  ? () async {
                                      try {
                                        _toggleLoading();
                                        final authService = ref.read(authenticationServiceProvider);
                                        final result = await authService.updateUserDisplayName(
                                          _textController.text.trim(),
                                        );
                                        if (!mounted) return;
                                        if (result == null) {
                                          ref.read(currentUserProvider.notifier).state =
                                              FirebaseAuth.instance.currentUser;
                                          showAppSnackBar(context: context, message: "Name updated successfully!");
                                        } else {
                                          showAppSnackBar(context: context, message: result);
                                        }
                                      } catch (e) {
                                        showAppSnackBar(context: context, message: "Failed to update name: $e");
                                      } finally {
                                        _toggleLoading();
                                      }
                                    }
                                  : null,
                            ),
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
