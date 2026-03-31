import 'package:flutter/material.dart';

import '../models/game_mode.dart';
import '../widgets/app_logo.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'multiplayer_game_screen.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({
    super.key,
    required this.mode,
    this.finalScore,
    this.highScore,
    this.isNewHighScore = false,
    this.playerOneScore,
    this.playerTwoScore,
    this.winnerLabel,
  });

  factory GameOverScreen.multiplayer({
    Key? key,
    required int playerOneScore,
    required int playerTwoScore,
    required String winnerLabel,
    required GameMode mode,
  }) {
    return GameOverScreen(
      key: key,
      mode: mode,
      playerOneScore: playerOneScore,
      playerTwoScore: playerTwoScore,
      winnerLabel: winnerLabel,
    );
  }

  final GameMode mode;
  final int? finalScore;
  final int? highScore;
  final bool isNewHighScore;
  final int? playerOneScore;
  final int? playerTwoScore;
  final String? winnerLabel;

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _badgeScale;

  bool get _isMultiplayer => widget.mode == GameMode.twoPlayers;

  Color get _winnerColor {
    if ((widget.winnerLabel ?? '').contains('Player 1')) {
      return const Color(0xFF54A8FF);
    }
    if ((widget.winnerLabel ?? '').contains('Player 2')) {
      return const Color(0xFFFF6B7A);
    }
    return const Color(0xFF8EA0C7);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _badgeScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF070B18),
              Color(0xFF101A34),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x77000000),
                        blurRadius: 28,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 64, showTitle: false),
                      const SizedBox(height: 18),
                      Text(
                        _isMultiplayer ? 'Match Finished' : 'Game Over',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 18),
                      if (_isMultiplayer)
                        ScaleTransition(
                          scale: _badgeScale,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _winnerColor.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: _winnerColor.withOpacity(0.35),
                              ),
                            ),
                            child: Text(
                              widget.winnerLabel ?? 'Draw',
                              style: TextStyle(
                                color: _winnerColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),
                      if (_isMultiplayer) ...[
                        _ScoreRow(
                          label: 'Player 1',
                          value: '${widget.playerOneScore ?? 0}',
                          valueColor: const Color(0xFF54A8FF),
                        ),
                        const SizedBox(height: 12),
                        _ScoreRow(
                          label: 'Player 2',
                          value: '${widget.playerTwoScore ?? 0}',
                          valueColor: const Color(0xFFFF6B7A),
                        ),
                      ] else ...[
                        _ScoreRow(
                          label: 'Final Score',
                          value: '${widget.finalScore ?? 0}',
                          valueColor: const Color(0xFF5EE7FF),
                        ),
                        const SizedBox(height: 12),
                        _ScoreRow(
                          label: 'High Score',
                          value: '${widget.highScore ?? 0}',
                          valueColor: const Color(0xFF8EA0C7),
                        ),
                      ],
                      if (!_isMultiplayer && widget.isNewHighScore) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14345F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'New high score unlocked!',
                            style: TextStyle(
                              color: Color(0xFF8EDBFF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder<void>(
                                pageBuilder: (_, __, ___) => _isMultiplayer
                                    ? const MultiplayerGameScreen()
                                    : const GameScreen(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Text('Play Again'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder<void>(
                                pageBuilder: (_, __, ___) => const HomeScreen(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Back to Menu'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD2DBF8),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
