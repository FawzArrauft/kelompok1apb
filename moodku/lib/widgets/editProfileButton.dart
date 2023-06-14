import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.pushNamed(context, '/editProfile');
      },
    );
  }
}
