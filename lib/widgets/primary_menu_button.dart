import 'package:flutter/material.dart';

class PrimaryMenuButton extends StatelessWidget {
  const PrimaryMenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    const primaryGradient = LinearGradient(
      colors: [
        Color(0xFF5EE7FF),
        Color(0xFF355CFF),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: isSecondary ? null : primaryGradient,
          color: isSecondary ? Colors.white.withOpacity(0.06) : null,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSecondary
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.06),
          ),
          boxShadow: isSecondary
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x55355CFF),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isSecondary ? 0.08 : 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
