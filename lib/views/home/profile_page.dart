import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/resources/components/memes_list.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:meme_app_final_project/views/home/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPostedSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          widget.user.imageURL ?? User.defaultProfileImageURL),
                    ),
                    Consumer<AuthProvider>(builder: (context, authProvider, _) {
                      if (authProvider.userDetails!.id == widget.user.id) {
                        return IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()));
                          },
                          icon: const Icon(Icons.edit),
                        );
                      } else {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                UserInfoRow(
                  title: "Name",
                  value: widget.user.name,
                ),
                UserInfoRow(
                  title: "Email",
                  value: widget.user.email,
                ),
                UserInfoRow(
                  title: "Phone",
                  value: widget.user.phone,
                ),
                const SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //       backgroundColor:
                //           WidgetStateProperty.all<Color>(Colors.teal),
                //       foregroundColor:
                //           WidgetStateProperty.all<Color>(Colors.white)),
                //   onPressed: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => EditProfile()));
                //   },
                //   child: Text("Edit"),
                // ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!isPostedSelected) {
                          setState(() {
                            isPostedSelected = true;
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 87, 84, 84)),
                          color: isPostedSelected ? Colors.teal : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text("Posted"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (isPostedSelected) {
                          setState(() {
                            isPostedSelected = false;
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 87, 84, 84)),
                          borderRadius: BorderRadius.circular(10),
                          color: !isPostedSelected ? Colors.teal : Colors.grey,
                        ),
                        child: const Center(
                          child: Text("Liked"),
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: isPostedSelected
                        ? widget.user.getPostedMemes()
                        : widget.user.getLikedMemes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MemesList(memes: snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Error Fetching: ${snapshot.error}"));
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title, value;
  const UserInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title :",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
