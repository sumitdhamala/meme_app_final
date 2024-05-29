// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, prefer_is_empty

import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostedMemeContainer extends StatelessWidget {
  final String id;
  final String name;
  final String createdAt;
  final String caption;
  final String filePath;

  final String? memeUploader;

  const PostedMemeContainer({
    super.key,
    required this.name,
    required this.id,
    required this.createdAt,
    this.caption = "",
    required this.filePath,
    required this.memeUploader,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController captionCntrl = TextEditingController();
    DateTime dateTime = DateTime.parse(createdAt);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(dateTime);

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
              backgroundImage: NetworkImage('$memeUploader'),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(formattedDate),
          ),
          const SizedBox(height: 5),
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(caption),
            ),
          Container(
            height: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(filePath),
              ),
            ),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}
