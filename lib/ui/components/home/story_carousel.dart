import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/ui/components/common/shimmer_box.dart';
import 'package:flutter/material.dart';

class StoryCarousel extends StatelessWidget {
  const StoryCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: CarouselView.weighted(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        flexWeights: const <int>[1, 4, 2, 1],
        elevation: 2,
        itemSnapping: true,
        consumeMaxWeight: false,
        children: List<Widget>.generate(40, (index) {
          return Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: "https://i.pravatar.cc/400?img=$index",
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeOut,
                  placeholder: (context, url) => ShimmerBox(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                          colors: [Colors.black.withAlpha((0.5 * 255).toInt()), Colors.transparent],
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
