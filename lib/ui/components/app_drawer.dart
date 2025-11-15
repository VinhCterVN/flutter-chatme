import 'package:chatme/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.surface,
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              children: [
                AppBar(
                  leading: Icon(Icons.arrow_back),
                  title: Text("Account", style: TextStyle(fontFamily: "Klavika")),
                  actions: [],
                  scrolledUnderElevation: 10,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      child: ClipOval(child: Image.asset('assets/images/avatar.png', fit: BoxFit.cover)),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle),
                        padding: EdgeInsetsDirectional.zero,
                        child: IconButton(
                          onPressed: () {},
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  currentUser?.displayName ?? "Unknown",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  currentUser?.email ?? "no email",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.home_rounded, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(leading: Icon(Icons.settings_rounded), title: Text('Settings'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
