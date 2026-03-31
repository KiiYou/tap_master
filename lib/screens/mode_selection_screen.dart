import 'package:flutter/material.dart';

import '../models/game_mode.dart';
import '../widgets/primary_menu_button.dart';
import 'game_screen.dart';
import 'multiplayer_game_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  void _openMode(BuildContext context, GameMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => mode == GameMode.singlePlayer
            ? const GameScreen()
            : const MultiplayerGameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Mode')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select a Game Mode',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Play solo to chase the high score or challenge a friend on the same device.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF60716E),
                        ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryMenuButton(
                    label: 'Single Player',
                    icon: Icons.person_rounded,
                    onPressed: () => _openMode(context, GameMode.singlePlayer),
                  ),
                  const SizedBox(height: 14),
                  PrimaryMenuButton(
                    label: 'Two Players',
                    icon: Icons.people_alt_rounded,
                    onPressed: () => _openMode(context, GameMode.twoPlayers),
                    isSecondary: true,
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
