import 'package:flutter/material.dart';

import '../../models/meme.dart';
import 'meme_container.dart';

class MemesList extends StatelessWidget {
  final List<Meme> memes;
  const MemesList({
    required this.memes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: memes
            .map(
              (e) => MemeContainer(
                meme: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
