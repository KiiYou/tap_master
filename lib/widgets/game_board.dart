import 'package:flutter/material.dart';

import '../services/game_controller.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.targetOffset,
    required this.isPaused,
    required this.onCircleTap,
    required this.playerLabel,
    required this.playerColor,
    required this.score,
    this.isHitActive = false,
  });

  final Offset targetOffset;
  final bool isPaused;
  final VoidCallback onCircleTap;
  final String playerLabel;
  final Color playerColor;
  final int score;
  final bool isHitActive;

  @override
  Widget build(BuildContext context) {
    final surfaceTint =
        Color.lerp(playerColor, Colors.white, 0.82) ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            surfaceTint,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: playerColor.withOpacity(0.18),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.86),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '$playerLabel  |  $score',
                  style: TextStyle(
                    color: playerColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
              left: targetOffset.dx,
              top: targetOffset.dy,
              child: GestureDetector(
                onTap: isPaused ? null : onCircleTap,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isPaused
                      ? 0.92
                      : isHitActive
                          ? 1.16
                          : 1,
                  child: Container(
                    width: GameController.circleSize,
                    height: GameController.circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(playerColor, Colors.white, 0.15) ??
                              playerColor,
                          playerColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: playerColor.withOpacity(
                            isHitActive ? 0.35 : 0.2,
                          ),
                          blurRadius: isHitActive ? 26 : 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isPaused)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x880F172A),
                  child: Center(
                    child: Text(
                      'Paused',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
