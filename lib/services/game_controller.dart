import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameState {
  const GameState({
    required this.score,
    required this.timeLeft,
    required this.circleOffset,
    required this.isGameOver,
    required this.isPaused,
    required this.boardSize,
    required this.isHitActive,
    required this.moveTick,
  });

  factory GameState.initial() {
    return const GameState(
      score: 0,
      timeLeft: 30,
      circleOffset: Offset.zero,
      isGameOver: false,
      isPaused: false,
      boardSize: Size.zero,
      isHitActive: false,
      moveTick: 0,
    );
  }

  final int score;
  final int timeLeft;
  final Offset circleOffset;
  final bool isGameOver;
  final bool isPaused;
  final Size boardSize;
  final bool isHitActive;
  final int moveTick;

  GameState copyWith({
    int? score,
    int? timeLeft,
    Offset? circleOffset,
    bool? isGameOver,
    bool? isPaused,
    Size? boardSize,
    bool? isHitActive,
    int? moveTick,
  }) {
    return GameState(
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      circleOffset: circleOffset ?? this.circleOffset,
      isGameOver: isGameOver ?? this.isGameOver,
      isPaused: isPaused ?? this.isPaused,
      boardSize: boardSize ?? this.boardSize,
      isHitActive: isHitActive ?? this.isHitActive,
      moveTick: moveTick ?? this.moveTick,
    );
  }
}

class GameController {
  GameController({Random? random}) : _random = random ?? Random();

  static const double circleSize = 76;
  static const double boardPadding = 16;

  final Random _random;

  GameState _state = GameState.initial();
  GameState get state => _state;

  VoidCallback? onChanged;

  Timer? _countdownTimer;
  Timer? _movementTimer;
  Timer? _hitEffectTimer;

  void updateBoardSize(Size size) {
    if (size.isEmpty || size == _state.boardSize) {
      return;
    }

    _state = _state.copyWith(boardSize: size);
    _moveCircle();
    _notify();
  }

  void startGame() {
    _cancelTimers();
    _state = GameState.initial().copyWith(
      boardSize: _state.boardSize,
      isHitActive: false,
    );
    _moveCircle();
    _startTimers();
    _notify();
  }

  void togglePause() {
    if (_state.isGameOver) {
      return;
    }

    final nextPausedValue = !_state.isPaused;
    _state = _state.copyWith(isPaused: nextPausedValue);

    if (nextPausedValue) {
      _cancelTimers();
    } else {
      _startTimers();
    }

    _notify();
  }

  void tapCircle() {
    if (_state.isGameOver || _state.isPaused) {
      return;
    }

    _state = _state.copyWith(
      score: _state.score + 1,
      isHitActive: true,
    );
    _moveCircle();
    _hitEffectTimer?.cancel();
    _hitEffectTimer = Timer(const Duration(milliseconds: 180), () {
      _state = _state.copyWith(isHitActive: false);
      _notify();
    });
    _notify();
  }

  void dispose() {
    _cancelTimers();
  }

  void _startTimers() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.isPaused || _state.isGameOver) {
        return;
      }

      if (_state.timeLeft <= 1) {
        _state = _state.copyWith(
          timeLeft: 0,
          isGameOver: true,
          isPaused: false,
        );
        _cancelTimers();
        _notify();
        return;
      }

      _state = _state.copyWith(timeLeft: _state.timeLeft - 1);
      _notify();
    });

    _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.isPaused || _state.isGameOver) {
        return;
      }

      _moveCircle();
      _notify();
    });
  }

  void _moveCircle() {
    final boardSize = _state.boardSize;
    if (boardSize.isEmpty) {
      return;
    }

    final maxX = max(
      0.0,
      boardSize.width - circleSize - (boardPadding * 2),
    );
    final maxY = max(
      0.0,
      boardSize.height - circleSize - (boardPadding * 2),
    );

    _state = _state.copyWith(
      circleOffset: Offset(
        boardPadding + (_random.nextDouble() * maxX),
        boardPadding + (_random.nextDouble() * maxY),
      ),
      moveTick: _state.moveTick + 1,
    );
  }

  void _cancelTimers() {
    _countdownTimer?.cancel();
    _movementTimer?.cancel();
    _hitEffectTimer?.cancel();
    _countdownTimer = null;
    _movementTimer = null;
    _hitEffectTimer = null;
  }

  void _notify() {
    onChanged?.call();
  }
}
