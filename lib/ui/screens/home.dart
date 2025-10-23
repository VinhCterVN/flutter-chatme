import 'package:chatme/helper/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        showAppSnackBar(context: context, message: "Refreshed!", duration: const Duration(seconds: 1));
      },
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: _SearchBarDelegate(onChanged: (value) => setState(() {}))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  onTap: () {},
                  onLongPress: () async {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.info_outline),
                                title: const Text('View Profile'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showAppSnackBar(
                                    context: context,
                                    message: "View Profile tapped",
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.message_outlined),
                                title: const Text('Send Message'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showAppSnackBar(
                                    context: context,
                                    message: "Send Message tapped",
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  leading: CircleAvatar(
                    backgroundImage: Image.network("https://i.pravatar.cc/${100 + index}").image,
                    radius: 25,
                  ),
                  title: Text("Handsome User"),
                ),
              ),
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final ValueChanged<String> onChanged;

  _SearchBarDelegate({required this.onChanged});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      key: const Key('search_bar'),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            hintText: "Search...",
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: controller.openView,
            onChanged: (_) => controller.openView(),
            onSubmitted: (val) {
              showAppSnackBar(
                context: context,
                message: "Search submitted: $val",
                duration: const Duration(seconds: 2),
              );
            },
          );
        },
        viewShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        // viewBackgroundColor: Theme.of(context).colorScheme.surfaceDim,
        suggestionsBuilder: (BuildContext context, SearchController controller) =>
            List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(title: Text(item), style: ListTileStyle.list);
            }),
        isFullScreen: true,
      ),
    );
  }

  @override
  double get maxExtent => 65.0;

  @override
  double get minExtent => 65.0;

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}
