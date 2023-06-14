import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoodTracker(),
    );
  }
}

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  String dropdownValue = 'Senang';
  List<String> moodList = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Catatan Suasana Hati',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'Senang',
                child: Row(
                  children: [
                    Icon(Icons.sentiment_very_satisfied),
                    SizedBox(width: 8),
                    Text('Senang'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Sedih',
                child: Row(
                  children: [
                    Icon(Icons.sentiment_very_dissatisfied),
                    SizedBox(width: 8),
                    Text('Sedih'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Marah',
                child: Row(
                  children: [
                    Icon(Icons.sentiment_very_dissatisfied),
                    SizedBox(width: 8),
                    Text('Marah'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Takut',
                child: Row(
                  children: [
                    Icon(Icons.sentiment_very_dissatisfied),
                    SizedBox(width: 8),
                    Text('Takut'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Netral',
                child: Row(
                  children: [
                    Icon(Icons.sentiment_neutral),
                    SizedBox(width: 8),
                    Text('Netral'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                moodList.add(dropdownValue);
                saveMoodToFirestore(dropdownValue);
              });
            },
            child: Text('Simpan'),
          ),
          SizedBox(height: 16),
          Text(
            'Daftar Catatan Suasana Hati',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('moods').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final moods = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final mood = moods[index].data() as Map<String, dynamic>;
                      final moodText = mood['mood'];
                      final timestamp = mood['timestamp'] as Timestamp;
                      final dateTime = timestamp.toDate();

                      return ListTile(
                        title: Text('Catatan Hari ${index + 1}'),
                        subtitle: Text('Suasana Hati: $moodText'),
                        trailing: Text('Timestamp: $dateTime'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveMoodToFirestore(String mood) async {
    await firestore.collection('moods').add({
      'mood': mood,
      'timestamp': DateTime.now(),
    });
  }
}
