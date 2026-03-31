import 'package:flutter/material.dart';

class CenterMatchHud extends StatelessWidget {
  const CenterMatchHud({
    super.key,
    required this.timeLeft,
    required this.playerOneScore,
    required this.playerTwoScore,
  });

  final int timeLeft;
  final int playerOneScore;
  final int playerTwoScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF101A34).withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${timeLeft}s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              children: [
                const TextSpan(
                  text: 'P1 ',
                  style: TextStyle(color: Color(0xFF67B8FF)),
                ),
                TextSpan(
                  text: '$playerOneScore',
                  style: const TextStyle(color: Colors.white),
                ),
                const TextSpan(
                  text: '  |  ',
                  style: TextStyle(color: Color(0xFF8EA0C7)),
                ),
                const TextSpan(
                  text: 'P2 ',
                  style: TextStyle(color: Color(0xFFFF7A7A)),
                ),
                TextSpan(
                  text: '$playerTwoScore',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
