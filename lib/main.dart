import 'package:flutter/material.dart';
import 'package:flutter_timer/time_display.dart';
import 'package:flutter_timer/timer.dart';
import 'package:flutter_timer/timer_button.dart';
import 'package:flutter_timer/timer_controls.dart';
import 'package:flutter_timer/timer_dial.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  EggTimer timer;

  _MyAppState() {
    timer = EggTimer(
      maxTime: const Duration(minutes: 6),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      timer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      timer.currentTime = newTime;
      timer.resume();
    });
  }

  _onTimerUpdate() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              TimeDisplay(
                eggTimerState: timer.state,
                selectionTime: timer.lastStartTime,
                countdownTime: timer.currentTime,
              ),
              TimerDial(
                timerState: timer.state,
                currentTime: timer.currentTime,
                maxTime: timer.maxTime,
                ticksPerSection: 5,
                onTimeSelected: _onTimeSelected,
                onDialStopTurning: _onDialStopTurning,

              ),
              Expanded(
                child: Container(),
              ),
              TimerControls(
                timerState: timer.state,
                onPause: () {
                 setState(() {
                   timer.pause();
                 });
                },
                onResume: () {
                  setState(() {
                    timer.resume();
                  });
                },
                onRestart: () {
                  setState(() {
                    timer.restart();
                  });
                },
                onReset: () {
                  setState(() {
                    timer.reset();
                  });
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
