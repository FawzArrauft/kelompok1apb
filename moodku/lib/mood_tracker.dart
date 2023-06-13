import 'package:flutter/material.dart';

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  String dropdownValue = 'Senang';

  List<String> moodList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: Text('Senang'),
            ),
            DropdownMenuItem(
              value: 'Sedih',
              child: Text('Sedih'),
            ),
            DropdownMenuItem(
              value: 'Marah',
              child: Text('Marah'),
            ),
            DropdownMenuItem(
              value: 'Takut',
              child: Text('Takut'),
            ),
            DropdownMenuItem(
              value: 'Netral',
              child: Text('Netral'),
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              moodList.add(dropdownValue);
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
          child: ListView.builder(
            itemCount: moodList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Catatan Hari ${index + 1}'),
                subtitle: Text('Suasana Hati: ${moodList[index]}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
