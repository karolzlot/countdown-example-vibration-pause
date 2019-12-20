import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

void main() => runApp(MaterialApp(home: CountdownCard()));

class CountdownCard extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _CountdownCardState createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  Timer _timer;
  int _start = 0;
  bool _vibrationActive = false;

  void startTimer(int timerDuration) {
    if (_timer != null) {
      _timer.cancel();
      cancelVibrate();
    }
    setState(() {
      _start = timerDuration;
    });
    const oneSec = const Duration(seconds: 1);
    print('test');
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            print('alarm');
            vibrate();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void cancelVibrate() {
    _vibrationActive = false;
    Vibration.cancel();
  }

  void vibrate() async {
    _vibrationActive = true;
    if (await Vibration.hasVibrator()) {
      while (_vibrationActive) {
        Vibration.vibrate(duration: 1000);
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
  }

  void unpauseTimer() => startTimer(_start);

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Countdown'),
        ),
        body: Wrap(children: <Widget>[
          Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  startTimer(10);
                },
                child: Text("start"),
              ),
              Text("$_start"),
              RaisedButton(
                onPressed: () {
                  pauseTimer();
                },
                child: Text("pause"),
              ),
              RaisedButton(
                onPressed: () {
                  unpauseTimer();
                },
                child: Text("unpause"),
              ),
              RaisedButton(
                onPressed: () {
                  cancelVibrate();
                },
                child: Text("stop alarm"),
              ),
            ],
          ),
        ]));
  }
}
