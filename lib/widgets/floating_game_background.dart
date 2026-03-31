import 'package:flutter/material.dart';

class FloatingGameBackground extends StatelessWidget {
  const FloatingGameBackground({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            _orb(
              size: 180,
              left: -30,
              top: 40 + (animation.value * 18),
              color: const Color(0xFF355CFF).withOpacity(0.18),
            ),
            _orb(
              size: 120,
              right: 24,
              top: 120 - (animation.value * 12),
              color: const Color(0xFFFF5B7A).withOpacity(0.16),
            ),
            _orb(
              size: 140,
              left: 40,
              bottom: 70 - (animation.value * 16),
              color: const Color(0xFF42E8E0).withOpacity(0.12),
            ),
          ],
        );
      },
    );
  }

  Widget _orb({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
