// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, prefer_is_empty

import 'package:meme_app_final_project/models/user.dart';
import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/provider/meme_provider.dart';
import 'package:meme_app_final_project/views/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/meme.dart';

class MemeContainer extends StatelessWidget {
  final Meme meme;

  const MemeContainer({
    super.key,
    required this.meme,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController captionCntrl = TextEditingController();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(meme.createdAt);

    var prov = Provider.of<AuthProvider>(context, listen: false);
    String userId = prov.userDetails!.id;
    // var mProv=Provider.of<MemeProvider>(context,listen: false);
    // String ? memeUploader=mProv.memesList[index]["uploadedBy"]["imageURL"];

    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  meme.uploadedBy.imageURL ?? User.defaultProfileImageURL),
            ),
            title: Consumer<MemeProvider>(builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfilePage(
                      user: meme.uploadedBy,
                    );
                  }));
                },
                child: Text(
                  meme.uploadedBy.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
            subtitle: Text(formattedDate),
            trailing: Consumer<MemeProvider>(
              builder: (context, provMeme, child) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case "delete":
                        {
                          provMeme.deleteMeme(meme.id, context);
                          break;
                        }
                      case "edit":
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Edit caption"),
                                content: TextField(
                                  controller: captionCntrl,
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          provMeme.editMeme(meme.id,
                                              captionCntrl.text, context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Confirm"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancle'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                    ];
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          if (meme.caption != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(meme.caption!),
            ),
          Container(
            height: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(meme.filePath),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Consumer<MemeProvider>(
                    builder: (context, value, child) {
                      return IconButton(
                        onPressed: () {
                          value.toggleLike(meme.id);
                        },
                        icon: Icon(
                          meme.likes.contains(userId)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: meme.likes.contains(userId)
                              ? Colors.red
                              : Colors.black,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(" ${meme.likes.length} likes"),
                ],
              ),
              const Icon(
                Icons.bookmark_outline,
                size: 30,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}
