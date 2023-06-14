import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySliderApp extends StatefulWidget {
  @override
  _MySliderAppState createState() => _MySliderAppState();
}

class _MySliderAppState extends State<MySliderApp> {
  int _value = 6;
  List<String> moodList = [];

  Future<void> saveEnergyToFirestore(String energy) async {
    try {
      await FirebaseFirestore.instance
          .collection('energy_records')
          .add({'energy': energy});
    } catch (e) {
      print('Error saving energy record: $e');
    }
  }

  Future<List<String>> fetchEnergyRecords() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('energy_records').get();

      List<String> records =
          querySnapshot.docs.map((doc) => doc['energy'].toString()).toList();

      return records;
    } catch (e) {
      print('Error fetching energy records: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ukur Seberapa Besar Energi Anda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Slider(
                  value: _value.toDouble(),
                  min: 0.0,
                  max: 100.0,
                  divisions: 10,
                  activeColor: Colors.purple,
                  inactiveColor: Colors.purple.shade100,
                  thumbColor: Colors.pink,
                  label: '${_value.round()}',
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue.round();
                    });
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()} dollars';
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    String energy = _value.toString();
                    saveEnergyToFirestore(energy);
                    moodList.add(energy);
                  });
                },
                child: Text('Simpan'),
              ),
              SizedBox(height: 16),
              Text(
                'Mood Energy Record',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: fetchEnergyRecords(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      moodList = snapshot.data!;
                      return ListView.builder(
                        itemCount: moodList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Record ${index + 1}'),
                            subtitle: Text('Energy: ${moodList[index]}'),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
