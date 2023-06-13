import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MoodCharts extends StatelessWidget {
  //data dummy yang akan ditampilkan
  final List<Sales> data = [
    //kita masukan data ke dalam model
    Sales(day: "Senin", mood: 70),
    Sales(day: "Selasa", mood: 12),
    Sales(day: "Rabu", mood: 15),
    Sales(day: "Kamis", mood: 16),
    Sales(day: "Jumat", mood: 18),
    Sales(day: "Sabtu", mood: 100),
    Sales(day: "Minggu", mood: 18),
  ];

  @override
  Widget build(BuildContext context) {
    //setting diagram
    List<charts.Series<Sales, String>> series = [
      //charts.series memiliki 4 parameter wajib diisi
      //domainFn adalah wilayah/label/kelompok
      //measureFn adalah ukuran/nilai yang akan dibandingkan
      charts.Series(
        id: "Mood",
        data: data,
        domainFn: (Sales series, _) => series.day,
        measureFn: (Sales series, _) => series.mood,
      )
    ];

    return SafeArea(
      child: Center(
        child: Container(
          height: 400,
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Statisktik Mood Seseorang",
                  ),
                  Expanded(
                    //menampilkan chart
                    //tambahkan vertical: false jika ingin membuat chart horizontal
                    child: charts.BarChart(series, animate: true),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//membuat model
class Sales {
  final String day;
  final int mood;

  Sales({
    required this.day,
    required this.mood,
  });
}
