// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/resources/constant.dart';
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
      Future.delayed(Duration(milliseconds: 2200), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogInScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/bg.jpg'),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    "Meme",
                    textStyle: TextStyle(
                      fontFamily: 'SedgwickAve',
                      fontSize: 100,
                    ),
                    colors: [
                      primaryColor,
                      Colors.purple,
                    ],
                  )
                ],
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.0,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Start your day with joy'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            LoadingAnimationWidget.stretchedDots(color: primaryColor, size: 60)
          ],
        ),
      ),
    );
  }
}
