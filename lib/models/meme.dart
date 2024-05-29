import 'user.dart';

class Meme {
  List<String> likes;
  String id;
  String? caption;
  String filePath;
  User uploadedBy;
  DateTime createdAt;
  DateTime updatedAt;
  Meme({
    required this.likes,
    required this.id,
    this.caption,
    required this.filePath,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  static Meme parseFromJSON(Map<String, dynamic> rawMeme) {
    return Meme(
      likes:
          (rawMeme['likes'] as List<dynamic>).map((e) => e as String).toList(),
      id: rawMeme['_id'],
      caption: rawMeme['caption'],
      filePath: rawMeme['filePath'],
      uploadedBy: User.parseFromJSON(rawMeme['uploadedBy']),
      createdAt: DateTime.parse(rawMeme['createdAt']),
      updatedAt: DateTime.parse(rawMeme['updatedAt']),
    );
  }
}
