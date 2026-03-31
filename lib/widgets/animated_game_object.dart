import 'package:flutter/material.dart';

class AnimatedGameObject extends StatelessWidget {
  const AnimatedGameObject({
    super.key,
    required this.color,
    required this.isHitActive,
    required this.moveTick,
    required this.onTap,
    this.size = 76,
    this.isPaused = false,
  });

  final Color color;
  final bool isHitActive;
  final int moveTick;
  final VoidCallback onTap;
  final double size;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey<int>(moveTick),
      tween: Tween<double>(begin: 0.72, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutBack,
      builder: (context, moveScale, child) {
        final tapScale = isPaused
            ? 0.94
            : isHitActive
                ? 1.14
                : 1.0;

        return GestureDetector(
          onTap: isPaused ? null : onTap,
          child: Transform.scale(
            scale: moveScale * tapScale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: isHitActive ? size * 1.8 : size * 1.15,
                  height: isHitActive ? size * 1.8 : size * 1.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(isHitActive ? 0.18 : 0),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.7, end: 1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  builder: (context, opacityValue, _) {
                    return Opacity(
                      opacity: isHitActive ? (1 - opacityValue) : 0,
                      child: Container(
                        width: size * (1.1 + opacityValue),
                        height: size * (1.1 + opacityValue),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withOpacity(0.55),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: isPaused ? 0.7 : 1,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(color, Colors.white, 0.2) ?? color,
                          color,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(isHitActive ? 0.45 : 0.25),
                          blurRadius: isHitActive ? 28 : 16,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
