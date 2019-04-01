import 'package:flutter/material.dart';
import 'package:flutter_timer/timer.dart';
import 'package:flutter_timer/timer_button.dart';

class TimerControls extends StatefulWidget {
  final timerState;
  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;

  TimerControls({
    this.timerState,
    this.onPause,
    this.onReset,
    this.onRestart,
    this.onResume,
  });

  @override
  _TimerControlsState createState() => _TimerControlsState();
}

class _TimerControlsState extends State<TimerControls>
    with TickerProviderStateMixin {
  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();

    pauseResumeSlideController =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this)
          ..addListener(() => setState(() {}));
    pauseResumeSlideController.value = 1.0;
    restartResetFadeController =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this)
          ..addListener(() => setState(() {}));
    restartResetFadeController.value = 1.0;
  }

  @override
  void dispose() {
    pauseResumeSlideController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timerState == TimerState.ready) {
      pauseResumeSlideController.forward();
      restartResetFadeController.forward();
    } else if (widget.timerState == TimerState.running) {
      pauseResumeSlideController.reverse();
      restartResetFadeController.forward();
    } else if (widget.timerState == TimerState.paused) {
      pauseResumeSlideController.reverse();
      restartResetFadeController.reverse();
    }
    return Column(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - restartResetFadeController.value,
          child: Row(
            children: <Widget>[
              TimerButton(
                icon: Icons.refresh,
                text: 'RESTART',
                onPressed: widget.onRestart,
              ),
              Expanded(child: Container()),
              TimerButton(
                icon: Icons.arrow_back,
                text: 'RESET',
                onPressed: widget.onReset,
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0,
              100.0 * pauseResumeSlideController.value,
              0.0),
          child: TimerButton(
            icon: widget.timerState == TimerState.running
                ? Icons.pause
                : Icons.play_arrow,
            text: widget.timerState == TimerState.running ? 'PAUSE' : 'RESUME',
            onPressed: widget.timerState == TimerState.running
                ? widget.onPause
                : widget.onResume,
          ),
        ),
      ],
    );
  }
}
