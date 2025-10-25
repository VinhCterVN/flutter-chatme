import 'dart:async';

import 'package:chatme/helper/snack_bar.dart';
import 'package:chatme/ui/components/home/notes_carousel.dart';
import 'package:chatme/ui/components/home/story_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/chat_model.dart';
import '../../provider/chat_provider.dart';
import '../../service/chat_service.dart';
import '../components/list/chat_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController _scrollController;

  List<Chat> _chats = [];
  StreamSubscription<List<Chat>>? _sub;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    final chatService = ref.read(chatServiceProvider);
    _sub = chatService.streamChatList(ref).listen((newChats) {
      setState(() => _chats = newChats);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
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
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(onChanged: (value) => setState(() {}), chats: _chats),
          ),
          SliverToBoxAdapter(child: NotesCarousel()),
          SliverToBoxAdapter(child: StoryCarousel()),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chat = _chats[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ChatTile(chat: chat, index: index),
              );
            }, childCount: _chats.length),
          ),
        ],
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final ValueChanged<String> onChanged;
  final List<Chat> chats;

  _SearchBarDelegate({required this.onChanged, required this.chats});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SearchAnchor(
        isFullScreen: true,
        viewShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            hintText: "Search...",
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: controller.openView,
            onChanged: (_) => controller.openView(),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          final query = controller.text.toLowerCase();
          final filtered = chats.where((chat) {
            final name = chat.groupName ?? (chat.type == ChatType.group ? "Group Chat" : "Private Chat");
            return name.toLowerCase().contains(query);
          }).toList();

          return filtered.map((chat) => ChatTile(chat: chat, index: chats.indexOf(chat))).toList();
        },
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return chats != oldDelegate.chats;
  }
}
