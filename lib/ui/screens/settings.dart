import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          period: const Duration(milliseconds: 1000),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade300, // quan trọng nè!
          ),
        ),
      ),
    );
  }
}
