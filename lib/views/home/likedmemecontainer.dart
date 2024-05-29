import 'package:meme_app_final_project/provider/meme_provider.dart';
import 'package:meme_app_final_project/views/home/Liked.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Liked extends StatelessWidget {
  const Liked({super.key});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<MemeProvider>(context, listen: false);
    prov.getLikedMeme();
    return Consumer<MemeProvider>(builder: (context, value, child) {
      return Column(
        children: value.likedMemesList
            .map((e) => LikedMemeContainer(
                  name: e['uploadedBy']['name'],
                  caption: e['caption'] ?? "",
                  createdAt: e['createdAt'],
                  filePath: e['filePath'],
                  id: e["_id"],
                  memeUploader: e['uploadedBy']['imageUrl'],
                ))
            .toList(),
      );
    });
  }
}
