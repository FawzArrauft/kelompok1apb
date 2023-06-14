import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moodku/add_mood.dart';
import 'package:moodku/editprofile.dart';
import 'package:moodku/firebase_options.dart';
import 'package:moodku/location.dart';
import 'package:moodku/login_prototype.dart';
import 'package:moodku/signup.dart';
import 'package:moodku/mood_tracker.dart';
import 'package:moodku/mood_chart.dart';
import 'package:moodku/energi.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:moodku/widgets/editProfileButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getDataFromSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPrototype(),
        '/register': (context) => SignUpPage(),
        '/home': (context) => HomeScreen(),
        '/editProfile': (context) => editProfile()
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    MoodTracker(),
    AddMood(),
    MySliderApp(),
    MoodCharts(),
    // editProfile(),
    LocationPage()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mood Tracker'),
          actions: [EditProfileButton()],
        ),
        body: TabBarView(
          children: _pages,
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.blue,
          color: Colors.white,
          activeColor: Colors.white,
          style: TabStyle.react,
          items: [
            TabItem(icon: Icons.note, title: 'Catatan'),
            TabItem(icon: Icons.book, title: 'Jurnal'),
            // TabItem(icon: Icons.plus_one, title: 'Booster'),
            TabItem(icon: Icons.flash_on, title: 'Energy'),
            TabItem(icon: Icons.timeline, title: 'Recap'),
            TabItem(icon: Icons.map, title: 'Maps'),
          ],
        ),
      ),
    );
  }
}
