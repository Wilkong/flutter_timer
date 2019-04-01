import 'dart:async';

class EggTimer {
  final Duration maxTime;
  final Function onTimerUpdate;
  final Stopwatch stopwatch = new Stopwatch();
  TimerState state = TimerState.ready;
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);

  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    if (state == TimerState.ready) {
      _currentTime = newTime;
      lastStartTime = currentTime;
    }
  }

  void resume() {
    if(state == TimerState.running) {
      return;
    }

    if(state == TimerState.ready) {
      _currentTime = _roundToTheNearestMinute(_currentTime);
      lastStartTime = _currentTime;
    }

    state = TimerState.running;
    stopwatch.start();

    _tick();
  }

  Duration _roundToTheNearestMinute(Duration duration) {
    final seconds = duration != null ? duration.inSeconds : 0;
    return Duration(
      minutes: ( seconds / 60).round(),
    );
  }

  void pause() {
    if (state != TimerState.running) {
      return;
    }

    state = TimerState.paused;
    stopwatch.stop();

    if(null != onTimerUpdate) {
      onTimerUpdate();
    }
  }

  void restart(){
    if(state != TimerState.paused) {
      return;
    }
    state = TimerState.running;
    _currentTime = lastStartTime;
    stopwatch.reset();
    stopwatch.start();

    _tick();

  }

  void reset() {
    if(state != TimerState.paused) {
      return;
    }

    state = TimerState.ready;
    _currentTime = const Duration(seconds: 0);
    lastStartTime = _currentTime;
    stopwatch.reset();

    if(null != onTimerUpdate) {
      onTimerUpdate();
    }
  }

  void _tick() {
    _currentTime = lastStartTime - stopwatch.elapsed;


    if(_currentTime.inSeconds > 0) {
      Timer(const Duration(seconds: 1), _tick);
    } else {
      state = TimerState.ready;
    }
    if(null != onTimerUpdate) {
      onTimerUpdate();
    }
  }
}

enum TimerState { ready, running, paused }
