import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  Icon tileIcon;
  DrawerTile({super.key, required this.tileIcon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {},
      leading: tileIcon,
      title: const Text("Settings"),
    );
  }
}
