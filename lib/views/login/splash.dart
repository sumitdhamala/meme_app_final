// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/views/home/home_page.dart';
import 'package:meme_app_final_project/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _next();
    super.initState();
  }

  _next() async {
    var prov = Provider.of<AuthProvider>(context, listen: false);
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("tokens") != null) {
      prov.setAuthId(prefs.getString("tokens")!);
    }
    if (AuthProvider.authId.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 2200), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      Future.delayed(Duration(seconds: 10), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogInScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 219, 235),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/meme.png"),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                opacity: 0.08,
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/doodle.png",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 163),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Color.fromARGB(255, 63, 59, 59), size: 42),
            ),
          ),
        ],
      ),
    );
  }
}
