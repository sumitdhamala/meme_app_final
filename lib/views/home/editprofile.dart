import 'dart:io';

import 'package:meme_app_final_project/resources/constant.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController editedNameCntrl = TextEditingController();
  TextEditingController editedPhoneNumberCntrl = TextEditingController();

  XFile? profilePic;
  bool isProfilePic = false;
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                profilePic =
                    await picker.pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: profilePic != null
                  ? Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                              image: FileImage(File(profilePic!.path))),
                          color: const Color.fromARGB(255, 230, 224, 224)),
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://th.bing.com/th/id/OIP.2wRpI007gG7aZqFRrBmGRwHaFP?w=263&h=186&c=7&r=0&o=5&pid=1.7")),
                          color: const Color.fromARGB(255, 230, 224, 224)),
                    ),
            ),
            const Text(
              "Click above to upload or change profile picture",
              style: TextStyle(fontSize: 11, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: editedNameCntrl,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your full name ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: editedPhoneNumberCntrl,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                String token = AuthProvider.authId;

                var request = http.MultipartRequest(
                  "Put",
                  Uri.parse("$baseApi" "users" "/me"),
                );
                var headers = {"Authorization": "Bearer $token"};
                request.headers.addAll(headers);
                request.fields.addAll({
                  "phone": editedPhoneNumberCntrl.text,
                  "name": editedNameCntrl.text,
                });
                request.files.add(
                  await http.MultipartFile.fromPath(
                    "image",
                    profilePic!.path,
                    contentType: MediaType.parse(
                      lookupMimeType(profilePic!.path)!,
                    ),
                  ),
                );
                var response = await request.send();

                var responseBody = await response.stream.bytesToString();
                if (response.statusCode != 201) {
                  throw Exception("Failed to update profile: $responseBody");
                } else {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .checkToken();
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
