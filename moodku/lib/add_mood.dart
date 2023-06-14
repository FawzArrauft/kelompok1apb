import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AddMoodApp());
}

class AddMoodApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Mood',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddMood(),
    );
  }
}

class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  TextEditingController _moodController = TextEditingController();
  List<String> _moodList = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ceritakan Perasaanmu Hari Ini',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _moodController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          final moodText = _moodController.text;
                          _moodList.add(moodText);
                          saveMoodToFirestore(moodText);
                          _moodController.clear();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(234, 230, 187, 46),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('new_moods').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  _moodList = snapshot.data!.docs
                      .map((doc) => doc['mood'] as String)
                      .toList();

                  return ListView.builder(
                    itemCount: _moodList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Color.fromARGB(255, 255, 0, 0),
                          ),
                        ),
                        title: Text(
                          _moodList[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              final moodText = _moodList[index];
                              _moodList.removeAt(index);
                              deleteMoodFromFirestore(moodText);
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveMoodToFirestore(String mood) async {
    await firestore.collection('new_moods').add({
      'mood': mood,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> deleteMoodFromFirestore(String mood) async {
    final snapshot = await firestore
        .collection('new_moods')
        .where('mood', isEqualTo: mood)
        .get();
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }
}
