import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<editProfile> {
  String? profileImageUrl;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: const Color.fromARGB(255, 158, 211, 255),
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 5),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: profileImageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profileImageUrl!),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: const Color.fromARGB(255, 158, 211, 255),
                        ),
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showModalBottomSheet(context);
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Email Confirmation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter your Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Bio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: "Enter your bio",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    final currentUser = FirebaseFirestore.instance;
    if (currentUser != null) {
      final email = _emailController.text;
      final name = _nameController.text;
      final bio = _bioController.text;

      try {
        // Get a reference to the 'Users' collection
        final usersRef = FirebaseFirestore.instance.collection('Users');

        // Query the collection to find documents with matching email
        final querySnapshot =
            await usersRef.where('email', isEqualTo: email).get();

        if (querySnapshot.size > 0) {
          // Document with matching email found
          final userDoc = querySnapshot.docs[0];

          // Create a new 'profile' subcollection under the user document
          final profileCollectionRef = userDoc.reference.collection('profile');

          // Query the profile collection to find the existing profile document
          final profileQuerySnapshot = await profileCollectionRef.get();

          if (profileQuerySnapshot.size > 0) {
            // Profile document already exists, update the existing document
            final profileDoc = profileQuerySnapshot.docs[0];
            await profileDoc.reference.update({
              'name': name,
              'bio': bio,
              'email': email,
              'profileImageUrl': profileImageUrl,
            });
          } else {
            // Create a new profile document with an auto-generated ID
            await profileCollectionRef.add({
              'name': name,
              'bio': bio,
              'email': email,
              'profileImageUrl': profileImageUrl,
            });
          }
          // Show a snackbar or notification that the profile has been saved
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile saved successfully')),
          );
        } else {
          // No document found with matching email
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found with the current email')),
          );
        }
      } catch (e) {
        // Error handling
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(
                context); // Menutup BottomSheet ketika latar belakang ditekan
          },
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Pilih Profile Picture",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _takePicture();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _chooseFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _takePicture() async {
    // Mengambil gambar menggunakan kamera
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageFile = File(image.path);
      final storage = FirebaseStorage.instance;

      try {
        // Menginisialisasi Firebase jika belum
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }

        // Mendapatkan referensi ke Firebase Storage
        final storageRef = storage.ref().child('profile_picture.jpg');

        // Upload gambar ke Firebase Storage
        await storageRef.putFile(imageFile);

        // Mendapatkan URL unduhan gambar
        final downloadURL = await storageRef.getDownloadURL();

        // Lakukan sesuatu dengan URL unduhan gambar
        setState(() {
          profileImageUrl = downloadURL;
        });
      } catch (e) {
        // Penanganan kesalahan
        print('Error uploading profile picture: $e');
      }

      // Hapus file sementara
      await imageFile.delete();
    }
  }

  void _chooseFromGallery() async {
    // Memilih gambar dari galeri
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      final storage = FirebaseStorage.instance;

      try {
        // Menginisialisasi Firebase jika belum
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }

        // Mendapatkan referensi ke Firebase Storage
        final storageRef = storage.ref().child('profile_picture.jpg');

        // Upload gambar ke Firebase Storage
        await storageRef.putFile(imageFile);

        // Mendapatkan URL unduhan gambar
        final downloadURL = await storageRef.getDownloadURL();

        // Lakukan sesuatu dengan URL unduhan gambar
        setState(() {
          profileImageUrl = downloadURL;
        });
      } catch (e) {
        // Penanganan kesalahan
        print('Error uploading profile picture: $e');
      }

      // Hapus file sementara
      await imageFile.delete();
    }
  }
}
