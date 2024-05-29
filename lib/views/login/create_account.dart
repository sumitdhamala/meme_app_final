// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:meme_app_final_project/views/login/login.dart';
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:meme_app_final_project/resources/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _obsecureText = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isCreated = false;

  Future<void> verify() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      var response = await http.post(Uri.parse("${baseApi}auth/register"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailController.text,
            'password': passwordController.text,
            'name': userNameController.text,
            'phone': phoneController.text,
          }));
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        setState(() {
          isCreated = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Account Created")));
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogInScreen()));
        });
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
      body: Form(
        key: _formKey,
        child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back,",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign up to continue",
                  style: TextStyle(
                    fontSize: 18,
                    color: grey,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: Icon(
                      Icons.person_outline_outlined,
                      color: grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter your email';
                    }
                    // Regular expression for email validation
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
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
                  controller: phoneController,
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter your phone number';
                    }
                    // Regular expression for phone number validation
                    final phoneRegex = RegExp(r'^\d{10}$');
                    if (!phoneRegex.hasMatch(value!)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Phone",
                    prefixIcon: Icon(
                      Icons.phone_enabled_outlined,
                      color: grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obsecureText,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: grey,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      child: Icon(
                        _obsecureText ? Icons.visibility : Icons.visibility_off,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: cPasswordController,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Password did not match";
                    }
                    if (value == "") {
                      return "Password must be greater or equal to 8 characters!";
                    } else {
                      return null;
                    }
                  },
                  obscureText: _obsecureText,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: grey,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      child: Icon(
                        _obsecureText ? Icons.visibility : Icons.visibility_off,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {
                      verify();
                    },
                    child: !isCreated
                        ? CustomButton(
                            buttonName: "CREATE ACCOUNT",
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
                      "Already have an account ?",
                      style: TextStyle(color: grey),
                    ),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all<Color>(paleBlue)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
