import 'package:flutter/material.dart';

class MySliderApp extends StatefulWidget {
  @override
  _MySliderAppState createState() => _MySliderAppState();
}

class _MySliderAppState extends State<MySliderApp> {
  int _value = 6;
  List<String> moodList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Mood Energy'),
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
                new Expanded(
                    child: Slider(
                        value: _value.toDouble(),
                        min: 0.0,
                        max: 100.0,
                        divisions: 10,
                        activeColor: Colors.green,
                        inactiveColor: Colors.orange,
                        label: '${_value.round()}',
                        onChanged: (double newValue) {
                          setState(() {
                            _value = newValue.round();
                          });
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        })),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      moodList.add(_value.toString());
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
                  child: ListView.builder(
                    itemCount: moodList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Record ${index + 1}'),
                        subtitle: Text('Energy: ${moodList[index]}'),
                      );
                    },
                  ),
                ),
              ])),
        ));
  }
}
