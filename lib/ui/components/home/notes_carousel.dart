import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatme/ui/components/common/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scale_button/scale_button.dart';

class NotesCarousel extends ConsumerStatefulWidget {
  const NotesCarousel({super.key});

  @override
  ConsumerState<NotesCarousel> createState() => _NotesCarouselState();
}

class _NotesCarouselState extends ConsumerState<NotesCarousel> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 85),
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverToBoxAdapter(
            child: ScaleButton(
              child: Container(
                width: 65,
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withAlpha((0.3 * 255).toInt())),
                child: Icon(Icons.add, size: 30),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ScaleButton(
                onTap: () {},
                duration: const Duration(milliseconds: 150),
                bound: 0.1,
                child: Container(
                  width: 65,
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "https://i.pravatar.cc/150?img=${index + 1}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ShimmerBox(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
              childCount: 40,
            ),
          ),
        ],
      ),
    );
  }
}
