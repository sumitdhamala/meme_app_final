// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, prefer_const_constructors
import 'package:meme_app_final_project/resources/constant.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String buttonName;
  CustomButton({
    super.key,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          buttonName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
