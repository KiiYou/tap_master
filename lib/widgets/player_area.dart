import 'package:flutter/material.dart';

import 'animated_game_object.dart';
import 'app_logo.dart';

class PlayerArea extends StatelessWidget {
  const PlayerArea({
    super.key,
    required this.label,
    required this.score,
    required this.objectOffset,
    required this.playerColor,
    required this.gradientColors,
    required this.isPaused,
    required this.isHitActive,
    required this.moveTick,
    required this.onTapObject,
  });

  final String label;
  final int score;
  final Offset objectOffset;
  final Color playerColor;
  final List<Color> gradientColors;
  final bool isPaused;
  final bool isHitActive;
  final int moveTick;
  final VoidCallback onTapObject;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: playerColor.withOpacity(0.35),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '$label  |  $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: Opacity(
              opacity: 0.12,
              child: IgnorePointer(
                child: AppLogo(size: 32, showTitle: false),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 460),
            curve: Curves.easeInOutCubic,
            left: objectOffset.dx,
            top: objectOffset.dy,
            child: AnimatedGameObject(
              color: playerColor,
              isHitActive: isHitActive,
              isPaused: isPaused,
              moveTick: moveTick,
              onTap: onTapObject,
            ),
          ),
          if (isPaused)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.28),
                child: const Center(
                  child: Text(
                    'Paused',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
