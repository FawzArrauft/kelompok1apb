import 'package:flutter/material.dart';
import 'package:moodku/editprofile.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return editProfile();
          }),
        );
      },
    );
  }
}
