import 'package:meme_app_final_project/provider/auth_provider.dart';
import 'package:meme_app_final_project/provider/meme_provider.dart';
import 'package:meme_app_final_project/views/login/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MemeProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "poppins"),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
