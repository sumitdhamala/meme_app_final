import 'package:meme_app_final_project/provider/meme_provider.dart';
import 'package:meme_app_final_project/views/home/posted.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Posted extends StatelessWidget {
  const Posted({super.key});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<MemeProvider>(context, listen: false);
    prov.getLikedMeme();
    return Consumer<MemeProvider>(builder: (context, value, child) {
      return Column(
        children: value.postedMemesList
            .map((e) => PostedMemeContainer(
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
