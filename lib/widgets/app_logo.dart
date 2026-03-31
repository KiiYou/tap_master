import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.showSubtitle = false,
    this.showTitle = true,
  });

  final double size;
  final bool showSubtitle;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoMark(size: size),
        if (showTitle) ...[
          const SizedBox(height: 18),
          Text(
            'Tap Master',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
          ),
        ],
        if (showSubtitle) ...[
          const SizedBox(height: 8),
          Text(
            'Tap fast. Beat your best.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF9CAAC7),
                ),
          ),
        ],
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5EE7FF),
            Color(0xFF355CFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55355CFF),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: ClipOval(
          child: Image.asset(
            'assets/icons/app_icon.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.18),
                ),
                child: Center(
                  child: Container(
                    width: size * 0.26,
                    height: size * 0.26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF355CFF),
                      borderRadius: BorderRadius.circular(size * 0.07),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
