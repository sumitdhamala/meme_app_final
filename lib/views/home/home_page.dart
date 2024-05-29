import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/provider/meme_provider.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:meme_app_final_project/views/home/add_meme.dart';
import 'package:meme_app_final_project/views/home/drawer_content.dart';
import 'package:meme_app_final_project/views/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/components/memes_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String accessToken = "";

  @override
  void initState() {
    super.initState();
    showUserDetails();
  }

  Future<void> showUserDetails() async {
    var prov = Provider.of<AuthProvider>(context, listen: false);
    accessToken = AuthProvider.authId;
    // Perform additional user detail fetching if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        title: const Text(
          "Memes App",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(user: authProvider.userDetails!),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 25,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const DrawerContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        tooltip: "Add new post",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMeme()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<MemeProvider>(
          builder: (context, memeProvider, child) {
            return memeProvider.isFetchingDone
                ? MemesList(
                    memes: memeProvider.memesList,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
