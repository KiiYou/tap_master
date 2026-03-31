import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/high_score_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/floating_game_background.dart';
import '../widgets/primary_menu_button.dart';
import 'game_screen.dart';
import 'high_score_screen.dart';
import 'multiplayer_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final HighScoreService _highScoreService = HighScoreService();

  late final AnimationController _entryController;
  late final AnimationController _backgroundController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _backgroundAnimation;

  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final highScore = await _highScoreService.getHighScore();
    if (!mounted) {
      return;
    }

    setState(() {
      _highScore = highScore;
    });
  }

  Future<void> _openScreen(Widget screen) async {
    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          final offset = Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
      ),
    );
    _loadHighScore();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _backgroundController.dispose();
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
              Color(0xFF0D1530),
              Color(0xFF121E45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: FloatingGameBackground(animation: _backgroundAnimation),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppLogo(showSubtitle: true),
                            const SizedBox(height: 28),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    blurRadius: 30,
                                    offset: Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Best Score: $_highScore',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFDEE6FF),
                                        ),
                                  ),
                                  const SizedBox(height: 22),
                                  PrimaryMenuButton(
                                    label: 'Single Player',
                                    icon: Icons.person_rounded,
                                    onPressed: () => _openScreen(
                                      const GameScreen(),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  PrimaryMenuButton(
                                    label: 'Multiplayer',
                                    icon: Icons.groups_rounded,
                                    onPressed: () => _openScreen(
                                      const MultiplayerGameScreen(),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  PrimaryMenuButton(
                                    label: 'High Score',
                                    icon: Icons.emoji_events_outlined,
                                    onPressed: () => _openScreen(
                                      const HighScoreScreen(),
                                    ),
                                    isSecondary: true,
                                  ),
                                  const SizedBox(height: 14),
                                  PrimaryMenuButton(
                                    label: 'Exit',
                                    icon: Icons.exit_to_app_rounded,
                                    onPressed: SystemNavigator.pop,
                                    isSecondary: true,
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
