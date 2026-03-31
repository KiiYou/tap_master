import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PlayerAreaState {
  const PlayerAreaState({
    required this.score,
    required this.targetOffset,
    required this.boardSize,
    required this.isHitActive,
    required this.moveTick,
  });

  factory PlayerAreaState.initial() {
    return const PlayerAreaState(
      score: 0,
      targetOffset: Offset.zero,
      boardSize: Size.zero,
      isHitActive: false,
      moveTick: 0,
    );
  }

  final int score;
  final Offset targetOffset;
  final Size boardSize;
  final bool isHitActive;
  final int moveTick;

  PlayerAreaState copyWith({
    int? score,
    Offset? targetOffset,
    Size? boardSize,
    bool? isHitActive,
    int? moveTick,
  }) {
    return PlayerAreaState(
      score: score ?? this.score,
      targetOffset: targetOffset ?? this.targetOffset,
      boardSize: boardSize ?? this.boardSize,
      isHitActive: isHitActive ?? this.isHitActive,
      moveTick: moveTick ?? this.moveTick,
    );
  }
}

class MultiplayerGameState {
  const MultiplayerGameState({
    required this.timeLeft,
    required this.isPaused,
    required this.isGameOver,
    required this.playerOne,
    required this.playerTwo,
  });

  factory MultiplayerGameState.initial() {
    return MultiplayerGameState(
      timeLeft: 30,
      isPaused: false,
      isGameOver: false,
      playerOne: PlayerAreaState.initial(),
      playerTwo: PlayerAreaState.initial(),
    );
  }

  final int timeLeft;
  final bool isPaused;
  final bool isGameOver;
  final PlayerAreaState playerOne;
  final PlayerAreaState playerTwo;

  MultiplayerGameState copyWith({
    int? timeLeft,
    bool? isPaused,
    bool? isGameOver,
    PlayerAreaState? playerOne,
    PlayerAreaState? playerTwo,
  }) {
    return MultiplayerGameState(
      timeLeft: timeLeft ?? this.timeLeft,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
    );
  }
}

class MultiplayerGameController {
  MultiplayerGameController({Random? random}) : _random = random ?? Random();

  static const double targetSize = 74;
  static const double boardPadding = 14;

  final Random _random;

  MultiplayerGameState _state = MultiplayerGameState.initial();
  MultiplayerGameState get state => _state;

  VoidCallback? onChanged;

  Timer? _countdownTimer;
  Timer? _movementTimer;
  Timer? _playerOneHitTimer;
  Timer? _playerTwoHitTimer;

  void updateBoardSizes({
    required Size playerOneSize,
    required Size playerTwoSize,
  }) {
    if (_state.playerOne.boardSize == playerOneSize &&
        _state.playerTwo.boardSize == playerTwoSize) {
      return;
    }

    final nextPlayerOne = _state.playerOne.copyWith(boardSize: playerOneSize);
    final nextPlayerTwo = _state.playerTwo.copyWith(boardSize: playerTwoSize);

    _state = _state.copyWith(
      playerOne: nextPlayerOne,
      playerTwo: nextPlayerTwo,
    );

    _moveTargetForPlayer(1);
    _moveTargetForPlayer(2);
    _notify();
  }

  void startGame() {
    _cancelTimers();
    _state = MultiplayerGameState.initial().copyWith(
      playerOne: _state.playerOne.copyWith(score: 0, isHitActive: false),
      playerTwo: _state.playerTwo.copyWith(score: 0, isHitActive: false),
    );
    _moveTargetForPlayer(1);
    _moveTargetForPlayer(2);
    _startTimers();
    _notify();
  }

  void togglePause() {
    if (_state.isGameOver) {
      return;
    }

    final nextPaused = !_state.isPaused;
    _state = _state.copyWith(isPaused: nextPaused);

    if (nextPaused) {
      _cancelCoreTimers();
    } else {
      _startTimers();
    }

    _notify();
  }

  void onPlayerTapped(int playerNumber) {
    if (_state.isGameOver || _state.isPaused) {
      return;
    }

    if (playerNumber == 1) {
      _state = _state.copyWith(
        playerOne: _state.playerOne.copyWith(
          score: _state.playerOne.score + 1,
          isHitActive: true,
        ),
      );
      _moveTargetForPlayer(1);
      _playerOneHitTimer?.cancel();
      _playerOneHitTimer = Timer(const Duration(milliseconds: 180), () {
        _state = _state.copyWith(
          playerOne: _state.playerOne.copyWith(isHitActive: false),
        );
        _notify();
      });
    } else {
      _state = _state.copyWith(
        playerTwo: _state.playerTwo.copyWith(
          score: _state.playerTwo.score + 1,
          isHitActive: true,
        ),
      );
      _moveTargetForPlayer(2);
      _playerTwoHitTimer?.cancel();
      _playerTwoHitTimer = Timer(const Duration(milliseconds: 180), () {
        _state = _state.copyWith(
          playerTwo: _state.playerTwo.copyWith(isHitActive: false),
        );
        _notify();
      });
    }

    _notify();
  }

  String getWinnerLabel() {
    if (_state.playerOne.score > _state.playerTwo.score) {
      return 'Player 1 Wins';
    }
    if (_state.playerTwo.score > _state.playerOne.score) {
      return 'Player 2 Wins';
    }
    return 'Draw';
  }

  void dispose() {
    _cancelTimers();
  }

  void _startTimers() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.isPaused || _state.isGameOver) {
        return;
      }

      if (_state.timeLeft <= 1) {
        _state = _state.copyWith(
          timeLeft: 0,
          isPaused: false,
          isGameOver: true,
        );
        _cancelTimers();
        _notify();
        return;
      }

      _state = _state.copyWith(timeLeft: _state.timeLeft - 1);
      _notify();
    });

    _movementTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.isPaused || _state.isGameOver) {
        return;
      }

      _moveTargetForPlayer(1);
      _moveTargetForPlayer(2);
      _notify();
    });
  }

  void _moveTargetForPlayer(int playerNumber) {
    final player = playerNumber == 1 ? _state.playerOne : _state.playerTwo;
    final boardSize = player.boardSize;
    if (boardSize.isEmpty) {
      return;
    }

    final maxX = max(
      0.0,
      boardSize.width - targetSize - (boardPadding * 2),
    );
    final maxY = max(
      0.0,
      boardSize.height - targetSize - (boardPadding * 2),
    );

    final nextPlayer = player.copyWith(
      targetOffset: Offset(
        boardPadding + (_random.nextDouble() * maxX),
        boardPadding + (_random.nextDouble() * maxY),
      ),
      moveTick: player.moveTick + 1,
    );

    _state = playerNumber == 1
        ? _state.copyWith(playerOne: nextPlayer)
        : _state.copyWith(playerTwo: nextPlayer);
  }

  void _cancelCoreTimers() {
    _countdownTimer?.cancel();
    _movementTimer?.cancel();
    _countdownTimer = null;
    _movementTimer = null;
  }

  void _cancelTimers() {
    _cancelCoreTimers();
    _playerOneHitTimer?.cancel();
    _playerTwoHitTimer?.cancel();
    _playerOneHitTimer = null;
    _playerTwoHitTimer = null;
  }

  void _notify() {
    onChanged?.call();
  }
}
