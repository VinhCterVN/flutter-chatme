import 'package:chatme/helper/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_provider.dart';

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
    final user = ref.watch(currentUserProvider);

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(pinned: true, delegate: _SearchBarDelegate(onChanged: (value) => setState(() {}))),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/avatar.png') as ImageProvider,
                  radius: 25,
                ),
                title: Text("DumpSit"),
              ),
            ),
            childCount: 100,
          ),
        ),
      ],
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
