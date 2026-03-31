import 'package:shared_preferences/shared_preferences.dart';

class HighScoreService {
  static const String _highScoreKey = 'tap_master_high_score';

  Future<int> getHighScore() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_highScoreKey) ?? 0;
  }

  Future<int> saveIfHigher(int score) async {
    final preferences = await SharedPreferences.getInstance();
    final currentHighScore = preferences.getInt(_highScoreKey) ?? 0;

    if (score > currentHighScore) {
      await preferences.setInt(_highScoreKey, score);
      return score;
    }

    return currentHighScore;
  }
}
