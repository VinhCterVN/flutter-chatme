import 'package:chatme/data/model/chat_model.dart';
import 'package:chatme/provider/auth_provider.dart';
import 'package:chatme/provider/chat_provider.dart';
import 'package:chatme/provider/user_provider.dart';
import 'package:chatme/service/api_service.dart';
import 'package:chatme/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactsPage extends ConsumerWidget {
  final apiService = ApiService();

  ContactsPage({super.key});

  Future<dynamic> fetchUsers() async => apiService.get();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatService = ref.watch(chatServiceProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userService = ref.watch(userServiceProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await userService.listUsers();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            FutureBuilder(
              future: userService.listUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No contacts found.');
                } else {
                  final users = snapshot.data as List<dynamic>;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        if (user['uid'] == currentUser?.uid) return const SizedBox.shrink();
                        return ListTile(
                          onTap: () async {
                            Chat chat = await chatService.getOrCreatePrivate(
                              uuidA: currentUser!.uid,
                              uuidB: user['uid'],
                            );
                            if (!context.mounted) return;
                            context.pushNamed(
                              'ChatDetails',
                              pathParameters: {
                                'type': ChatType.private.name,
                                'roomId': chat.id,
                                'title': user['displayName'] ?? 'Chat',
                              },
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: (user['photoUrl'] as String).isNotEmpty
                                ? NetworkImage(user['photoUrl'])
                                : const AssetImage('assets/images/avatar.png') as ImageProvider,
                          ),
                          title: Text(
                            user['displayName'] ?? 'Unnamed',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
