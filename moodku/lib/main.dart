import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moodku/add_mood.dart';
import 'package:moodku/countdown_timer.dart';
import 'package:moodku/firebase_options.dart';
import 'package:moodku/login_prototype.dart';
import 'package:moodku/signup.dart';
import 'package:moodku/mood_tracker.dart';
import 'package:moodku/mood_chart.dart';
import 'package:moodku/energi.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPrototype(),
        '/register': (context) => SignUpPage(),
        '/home': (context) => DefaultTabController(
              length: 5,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Mood Tracker'),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48),
                    child: Container(
                      alignment: Alignment.center,
                      child: TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: 'Catatan',
                          ),
                          Tab(
                            text: 'Mood Jurnal',
                          ),
                          Tab(
                            text: 'Mood Booster',
                          ),
                          Tab(
                            text: 'Mood Energy',
                          ),
                          Tab(
                            text: 'Recap Mood',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    MoodTracker(),
                    AddMood(),
                    Countdown(),
                    MySliderApp(),
                    MoodCharts(),
                  ],
                ),
              ),
            ),
      },
    );
  }
}
