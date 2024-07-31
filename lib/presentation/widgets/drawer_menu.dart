import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future logOut() async {
    final auth = AuthService();
    auth.userSignOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            // color: Colors.amber,
            //        decoration: BoxDecoration(color: Colors.amberAccent),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Icon(
                  Icons.message_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text("H O M E"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text("S E T T I N G S"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("L O G O U T"),
              onTap: logOut,
            ),
          ),
        ],
      ),
    );
  }
}
