import 'package:chatme/ui/components/edge_aware_glow_image.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: <Widget>[
              ...List.generate(
                2,
                (_) =>  EdgeAwareGlowImage(
                  image: NetworkImage('https://picsum.photos/seed/picsum/1200/800'),
                  size: Size(MediaQuery.of(context).size.width, 220),
                  borderRadius: 0.0,
                ),
              ).expand((w) sync* {
                yield w;
                yield const SizedBox(height: 25);
              }).toList()..removeLast(),
            ],
          ),
        ),
      ),
    );
  }
}
