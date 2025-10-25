import 'package:chatme/ui/components/common/shimmer_box.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(width: double.infinity, height: double.infinity, child: ShimmerBox()),
    );
  }
}
