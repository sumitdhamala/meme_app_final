// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:meme_app_final_project/resources/custom_button.dart';
import 'package:meme_app_final_project/views/home/home_page.dart';
import 'package:meme_app_final_project/views/login/create_account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obsecureText = true;
  bool isRemember = true;
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      var response = await http.post(Uri.parse("${baseApi}auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailController.text,
            'password': passController.text,
          }));

      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isLogin = true;
        });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });

        //save to shared_preferences
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            "tokens", decodedResponse['tokens']['access']['token']);

        //set that token id
        var prov = Provider.of<AuthProvider>(context, listen: false);
        prov.setAuthId(decodedResponse['tokens']['access']['token']);
        await prov.checkToken();
        // print(prov.authId);
        // print(prefs.getString("tokens"));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(decodedResponse['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: 0.15,
            image: AssetImage("assets/images/bubbles.jpg"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Text(
                "Welcome Back,",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sign in to continue",
                style: TextStyle(
                  fontSize: 18,
                  color: grey,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: grey,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: grey,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: () {
                    login();
                  },
                  child: !isLogin
                      ? CustomButton(
                          buttonName: "Login",
                        )
                      : CircularProgressIndicator(
                          color: primaryColor,
                        )),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(color: grey),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(paleBlue),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccountPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
