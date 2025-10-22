import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class EdgeAwareGlowImage extends StatefulWidget {
  const EdgeAwareGlowImage({super.key, required this.image, this.size = const Size(360, 220), this.borderRadius = 16});

  final ImageProvider image;
  final Size size;
  final double borderRadius;

  @override
  State<EdgeAwareGlowImage> createState() => _EdgeAwareGlowImageState();
}

class _EdgeAwareGlowImageState extends State<EdgeAwareGlowImage> {
  Color left = Colors.black;
  Color right = Colors.black;
  Color top = Colors.black;
  Color bottom = Colors.black;
  bool ready = false;

  Future<void> _computePalette() async {
    final w = widget.size.width;
    final h = widget.size.height;
    final edge = 0.06;

    final palette = await PaletteGenerator.fromImageProvider(
      widget.image,

      size: Size(w, h),
      region: Rect.fromLTWH(0, 0, w, h),
      maximumColorCount: 32,
    );

    final sw = palette.paletteColors;
    Color pick(int i, [double darken = 0.0]) {
      if (sw.isEmpty) return Colors.black;
      final c = sw[i % sw.length].color;
      return Color.lerp(Colors.black, c, 0.85 - darken) ?? c;
    }

    setState(() {
      left = pick(0, 0.05);
      right = pick(1, 0.00);
      top = pick(2, 0.05);
      bottom = pick(3, 0.00);
      ready = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _computePalette();
  }

  @override
  Widget build(BuildContext context) {
    final shadows = ready
        ? [
            BoxShadow(
              color: top.withAlpha((255 * 0.25).toInt()),
              blurRadius: 48,
              spreadRadius: -8,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: bottom.withAlpha((255 * 0.25).toInt()),
              blurRadius: 64,
              spreadRadius: -10,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: left.withAlpha((255 * 0.25).toInt()),
              blurRadius: 56,
              spreadRadius: -10,
              offset: const Offset(-10, 0),
            ),
            BoxShadow(
              color: right.withAlpha((255 * 0.25).toInt()),
              blurRadius: 56,
              spreadRadius: -10,
              offset: const Offset(10, 0),
            ),
          ]
        : [const BoxShadow(color: Colors.black26, blurRadius: 32, spreadRadius: -8)];

    return Container(
      width: widget.size.width,
      height: widget.size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.borderRadius), boxShadow: shadows),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image(image: widget.image, fit: BoxFit.cover),
      ),
    );
  }
}
