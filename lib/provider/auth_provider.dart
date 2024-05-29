// ignore_for_file: unnecessary_string_interpolations, avoid_print

import 'dart:convert';

import 'package:meme_app_final_project/resources/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  static String authId = '';

  setAuthId(String id) {
    authId = id;
    notifyListeners();
  }

  static String? loggedUserID;
  User? userDetails;

  AuthProvider() {
    checkToken();
  }

  Future<void> checkToken() async {
    var prefs = await SharedPreferences.getInstance();

    String? tokenId = prefs.getString("tokens");
    if (tokenId != null) {
      authId = tokenId;
    }

    if (authId.isNotEmpty) {
      var response = await http.get(
        Uri.parse("$baseApi" "users/me"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authId'
        },
      );
      var decodedResponse = jsonDecode(response.body);
      userDetails = User.parseFromJSON(decodedResponse);
      loggedUserID = userDetails!.id;
      // print(authId);

      notifyListeners();
    } else {
      print("Auth id empty");
    }
    notifyListeners();
  }
}
