import 'dart:convert';

import '../provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import '../resources/constant.dart';
import 'meme.dart';

class User {
  static const String defaultProfileImageURL =
      "https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png";

  String email;
  String name;
  String phone;
  String? imageURL;
  String id;

  User({
    required this.email,
    required this.name,
    required this.phone,
    this.imageURL,
    required this.id,
  });

  static User parseFromJSON(Map<String, dynamic> rawUser) {
    return User(
      email: rawUser['email'],
      phone: rawUser['phone'],
      imageURL: rawUser['imageURL'],
      id: rawUser['id'],
      name: rawUser['name'],
    );
  }

  Future<List<Meme>> getLikedMemes() async {
    String token = AuthProvider.authId;

    var response = await http.get(Uri.parse("$baseApi" "memes" "/liked" "/$id"),
        headers: {'Authorization': 'Bearer $token'});

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedResponse as List<dynamic>)
          .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          "Error Fetching Liked Memes: ${decodedResponse['message']}");
    }
  }

  Future<List<Meme>> getPostedMemes() async {
    String token = AuthProvider.authId;

    var response = await http.get(Uri.parse("$baseApi" "memes" "/by" "/$id"),
        headers: {'Authorization': 'Bearer $token'});

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (decodedResponse as List<dynamic>)
          .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          "Error Fetching Posted Memes: ${decodedResponse['message']}");
    }
  }
}
