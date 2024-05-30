import 'dart:convert';

import 'package:meme_app_final_project/models/meme.dart';
import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemeProvider with ChangeNotifier {
  List<Meme> memesList = [];
  List<Map<String, dynamic>> likedMemesList = [];
  List<Map<String, dynamic>> postedMemesList = [];

  bool isFetchingDone = false;
  MemeProvider() {
    fetchMemes();
  }

  Future<void> fetchMemes() async {
    String token = AuthProvider.authId;
    var response = await http.get(
      Uri.parse("$baseApi" "memes"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      memesList = (decodedResponse as List<dynamic>)
          .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
          .toList();
      isFetchingDone = true;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> toggleLike(String id) async {
    String token = AuthProvider.authId;
    var response = await http.post(
      Uri.parse("$baseApi" "memes/" "$id" "/toggle-like"),
      headers: {'Authorization': 'Bearer $token'},
    );
    var decodedResponse = jsonDecode(response.body);
    for (var i = 0; i < memesList.length; i++) {
      if (memesList[i].id == id) {
        memesList[i].likes = (decodedResponse['likes'] as List<dynamic>)
            .map((e) => e as String)
            .toList();
        notifyListeners();
      }
    }
  }

  Future<void> deleteMeme(String id, context) async {
    String token = AuthProvider.authId;
    for (var i = 0; i < memesList.length; i++) {
      if (memesList[i].id == id) {
        if (memesList[i].uploadedBy.id == AuthProvider.loggedUserID) {
          {
            var response = await http.delete(
              Uri.parse("$baseApi" "memes/" "$id"),
              headers: {'Authorization': 'Bearer $token'},
            );
            memesList.removeAt(i);
          }
          notifyListeners();
        } else {}
      }
    }
  }

  Future<void> editMeme(String id, String cntrl, context) async {
    String token = AuthProvider.authId;

    var response = await http.patch(Uri.parse("$baseApi" "memes/" "$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({"caption": cntrl}));

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var i = 0; i < memesList.length; i++) {
        if (memesList[i].id == id) {
          memesList[i] = Meme.parseFromJSON(decodedResponse['meme']);
          notifyListeners();
        } else {
          print(decodedResponse['message']);
        }
      }
    
  }

  Future<void> getLikedMeme() async {
    String token = AuthProvider.authId;

    var response = await http.get(
        Uri.parse("$baseApi" "memes" "/liked" "/6652af0b295e72d0522dd1ea"),
        headers: {'Authorization': 'Bearer $token'});

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      likedMemesList = (decodedResponse as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      print(decodedResponse);
      notifyListeners();
    } else {
      print(decodedResponse['message']);
    }
    print(response.statusCode);
  }

  Future<void> getPostedMeme() async {
    String token = AuthProvider.authId;

    var response = await http.get(
        Uri.parse("$baseApi" "memes" "/by" "/6652af0b295e72d0522dd1ea"),
        headers: {'Authorization': 'Bearer $token'});

    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      postedMemesList = (decodedResponse as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } else {
      print(decodedResponse['message']);
    }
    print(response.statusCode);
  }
}
}