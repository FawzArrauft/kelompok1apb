import 'package:flutter/material.dart';

class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  TextEditingController _moodController = TextEditingController();
  List<String> _moodList = [];

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
                  'Coba ceritakan perasaanmu hari ini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _moodController,
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan perasaan',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _moodList.add(_moodController.text);
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
            child: ListView.builder(
              itemCount: _moodList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_moodList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
