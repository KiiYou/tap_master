import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_mode.dart';
import '../services/game_controller.dart';
import '../services/high_score_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/game_board.dart';
import '../widgets/stat_card.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final HighScoreService _highScoreService = HighScoreService();
  late final GameController _controller;

  bool _hasStarted = false;
  bool _isNavigatingToGameOver = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController()
      ..onChanged = () {
        if (!mounted) {
          return;
        }

        setState(() {});

        if (_controller.state.isGameOver && !_isNavigatingToGameOver) {
          _openGameOver();
        }
      };
  }

  Future<void> _openGameOver() async {
    _isNavigatingToGameOver = true;

    final finalScore = _controller.state.score;
    final oldHighScore = await _highScoreService.getHighScore();
    final savedHighScore = await _highScoreService.saveIfHigher(finalScore);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          finalScore: finalScore,
          highScore: savedHighScore,
          isNewHighScore: finalScore > oldHighScore,
          mode: GameMode.singlePlayer,
        ),
      ),
    );
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
        title: const Text('Tap Master'),
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
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF070B18),
                Color(0xFF0D1530),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth > 700 ? 32.0 : 16.0;
              final boardHeight = constraints.maxHeight * 0.68;
              final boardWidth = constraints.maxWidth - (horizontalPadding * 2);
              final boardSize = Size(boardWidth, boardHeight);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.updateBoardSize(boardSize);

                if (!_hasStarted) {
                  _hasStarted = true;
                  _controller.startGame();
                }
              });

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  16,
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth > 700
                              ? (boardWidth - 12) / 2
                              : boardWidth,
                          child: StatCard(
                            label: 'Score',
                            value: '${state.score}',
                            icon: Icons.touch_app_rounded,
                            accentColor: const Color(0xFF5EE7FF),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth > 700
                              ? (boardWidth - 12) / 2
                              : boardWidth,
                          child: StatCard(
                            label: 'Time Left',
                            value: '${state.timeLeft}s',
                            icon: Icons.timer_outlined,
                            accentColor: const Color(0xFF8EA0C7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Opacity(
                                opacity: 0.55,
                                child: AppLogo(size: 28, showTitle: false),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.isPaused
                                      ? 'Game paused. Tap play to continue.'
                                      : 'Tap the moving circle to score points.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: const Color(0xFF9CAAC7)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: GameBoard(
                              targetOffset: state.circleOffset,
                              isPaused: state.isPaused,
                              isHitActive: state.isHitActive,
                              onCircleTap: () {
                                HapticFeedback.selectionClick();
                                _controller.tapCircle();
                              },
                              playerLabel: 'Solo',
                              playerColor: const Color(0xFF355CFF),
                              score: state.score,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
