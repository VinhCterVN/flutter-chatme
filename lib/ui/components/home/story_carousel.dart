import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/ui/components/common/shimmer_box.dart';
import 'package:flutter/material.dart';

import '../../layout/fullscreen_image_page.dart';

class StoryCarousel extends StatefulWidget {
  const StoryCarousel({super.key});

  @override
  State<StoryCarousel> createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateToItem(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: CarouselView.weighted(
        controller: _controller,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        flexWeights: const <int>[2, 4, 3],
        elevation: 2,
        itemSnapping: true,
        consumeMaxWeight: true,
        onTap: (index) => Navigator.of(context, rootNavigator: true).push(
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black54,
              transitionDuration: Duration(milliseconds: 300),
              reverseTransitionDuration: Duration(milliseconds: 250),
              pageBuilder: (_, __, ___) =>
                  FullscreenImagePage(imageUrl: "https://i.pravatar.cc/400?img=$index", tag: index.toString()),
            ),
          ),
        children: List<Widget>.generate(40, (index) {
          return Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: index.toString(),
                  child: CachedNetworkImage(
                    imageUrl: "https://i.pravatar.cc/400?img=$index",
                    fit: BoxFit.cover,
                    placeholder: (_, __) => ShimmerBox(),
                    errorWidget: (_, __, ___) => Icon(Icons.error),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withAlpha((0.25 * 255).toInt()), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        "Image",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                          overflow: TextOverflow.fade,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
