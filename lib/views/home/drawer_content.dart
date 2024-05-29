// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/resources/components/drawer_tile.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:meme_app_final_project/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  Future<void> logOut() async {
    var prov = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Do you want to log out?",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primaryColor),
                        foregroundColor:
                            WidgetStatePropertyAll(secondaryColor),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInScreen()));
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primaryColor),
                        foregroundColor:
                            WidgetStatePropertyAll(secondaryColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                  ],
                ),
              ],
            ));

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("tokens", "");
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/736x/c6/c8/2a/c6c82a034d0b5e6312fbda7776c8aef7.jpg"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  prov.userDetails!.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  prov.userDetails!.email,
                  style: const TextStyle(fontSize: 15),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                DrawerTile(
                  tileIcon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                logOut();
              },
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text("LogOut"),
            )
          ],
        ),
      ),
    );
  }
}
