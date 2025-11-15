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

  void _openFullScreenSearch(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute(builder: (context) => _FullScreenSearchPage(chats: _chats)));
    FocusScope.of(context).unfocus();
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
            delegate: _SearchBarDelegate(onTap: () => _openFullScreenSearch(context), chats: _chats),
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
  final VoidCallback onTap;
  final List<Chat> chats;

  _SearchBarDelegate({required this.onTap, required this.chats});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SearchBar(
        hintText: "Search...",
        autoFocus: false,
        leading: const Icon(Icons.search),
        padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: onTap,
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

class _FullScreenSearchPage extends StatefulWidget {
  final List<Chat> chats;

  const _FullScreenSearchPage({required this.chats});

  @override
  State<_FullScreenSearchPage> createState() => _FullScreenSearchPageState();
}

class _FullScreenSearchPageState extends State<_FullScreenSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Chat> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = widget.chats;
    _controller.addListener(_filterChats);
  }

  @override
  void dispose() {
    _controller.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  void _filterChats() {
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChats = widget.chats;
      } else {
        _filteredChats = widget.chats.where((chat) {
          final name = chat.groupName ?? (chat.type == ChatType.group ? "Group Chat" : "Private Chat");
          return name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).toInt())),
          ),
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
              },
            ),
        ],
      ),
      body: _filteredChats.isEmpty
          ? Center(
              child: Text(
                _controller.text.isEmpty ? "Start typing to search" : "No results found",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _filteredChats.length,
              itemBuilder: (context, index) {
                final chat = _filteredChats[index];
                return ChatTile(chat: chat, index: widget.chats.indexOf(chat), onClick: Navigator.of(context).pop);
              },
            ),
    );
  }
}
