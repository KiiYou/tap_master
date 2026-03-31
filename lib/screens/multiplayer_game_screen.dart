import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_mode.dart';
import '../services/multiplayer_game_controller.dart';
import '../widgets/center_match_hud.dart';
import '../widgets/player_area.dart';
import 'game_over_screen.dart';

class MultiplayerGameScreen extends StatefulWidget {
  const MultiplayerGameScreen({super.key});

  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  late final MultiplayerGameController _controller;

  bool _hasStarted = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = MultiplayerGameController()
      ..onChanged = () {
        if (!mounted) {
          return;
        }

        setState(() {});

        if (_controller.state.isGameOver && !_isNavigating) {
          _openGameOver();
        }
      };
  }

  void _openGameOver() {
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => GameOverScreen.multiplayer(
          playerOneScore: _controller.state.playerOne.score,
          playerTwoScore: _controller.state.playerTwo.score,
          winnerLabel: _controller.getWinnerLabel(),
          mode: GameMode.twoPlayers,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _handleTap(int player) {
    HapticFeedback.selectionClick();
    _controller.onPlayerTapped(player);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tap Master Duel',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: state.isPaused ? 'Resume' : 'Pause',
            onPressed: _controller.togglePause,
            icon: Icon(
              state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const hudHeight = 86.0;
            const outerPadding = 14.0;
            final totalHeight = constraints.maxHeight - (outerPadding * 2);
            final areaHeight = ((totalHeight - hudHeight) / 2)
                .clamp(150.0, totalHeight)
                .toDouble();
            final boardWidth = constraints.maxWidth - (outerPadding * 2);
            final boardSize = Size(boardWidth, areaHeight);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.updateBoardSizes(
                playerOneSize: boardSize,
                playerTwoSize: boardSize,
              );

              if (!_hasStarted) {
                _hasStarted = true;
                _controller.startGame();
              }
            });

            return Padding(
              padding: const EdgeInsets.all(outerPadding),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: PlayerArea(
                          label: 'Player 1',
                          score: state.playerOne.score,
                          objectOffset: state.playerOne.targetOffset,
                          playerColor: const Color(0xFF54A8FF),
                          gradientColors: const [
                            Color(0xFF13203D),
                            Color(0xFF102A57),
                            Color(0xFF1E3C78),
                          ],
                          isPaused: state.isPaused,
                          isHitActive: state.playerOne.isHitActive,
                          moveTick: state.playerOne.moveTick,
                          onTapObject: () => _handleTap(1),
                        ),
                      ),
                      SizedBox(
                        height: hudHeight,
                        child: Center(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.0),
                                  Colors.blue.withOpacity(0.6),
                                  Colors.red.withOpacity(0.6),
                                  Colors.red.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PlayerArea(
                          label: 'Player 2',
                          score: state.playerTwo.score,
                          objectOffset: state.playerTwo.targetOffset,
                          playerColor: const Color(0xFFFF6B7A),
                          gradientColors: const [
                            Color(0xFF32131F),
                            Color(0xFF4B1524),
                            Color(0xFF6E2434),
                          ],
                          isPaused: state.isPaused,
                          isHitActive: state.playerTwo.isHitActive,
                          moveTick: state.playerTwo.moveTick,
                          onTapObject: () => _handleTap(2),
                        ),
                      ),
                    ],
                  ),
                  CenterMatchHud(
                    timeLeft: state.timeLeft,
                    playerOneScore: state.playerOne.score,
                    playerTwoScore: state.playerTwo.score,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
