import 'dart:async';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int _timeRemaining = 600;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _resetTimer() {
    setState(() {
      _timeRemaining = 600;
    });
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Mari hilangkan stres dalam 10 menit dengan melakukan yoga dan memfokuskan diri pada pernapasanmu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              _timeRemaining == 0
                  ? 'Waktu Habis!'
                  : '${(_timeRemaining / 60).floor().toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 72.0),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pauseTimer,
              child: Icon(Icons.pause),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: _resumeTimer,
              child: Icon(Icons.play_arrow),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
