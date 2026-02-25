import 'dart:math';
import '../data/app_strings.dart';

/// ELO Rating Calculator
/// Fixed point system based on user rank and question difficulty
class EloCalculator {
  /// Starting ELO for new users
  static const int startingElo = 100;
  
  /// Fixed point gains for correct answers [rank][difficulty-1]
  /// Ranks: Çaylak(<200), Yükselen(200-399), Deneyimli(400-599),
  ///        Uzman(600-799), Usta(800-999), Üstat(1000+)
  /// Difficulty: 1=Easy, 2=Medium, 3=Hard
  static const List<List<int>> _correctPoints = [
    [8, 12, 18],   // Çaylak
    [6, 10, 15],   // Yükselen
    [5, 8, 12],    // Deneyimli
    [4, 6, 10],    // Uzman
    [3, 5, 8],     // Usta
    [2, 4, 6],     // Üstat
  ];

  /// Fixed point losses for wrong answers [rank][difficulty-1]
  static const List<List<int>> _wrongPoints = [
    [2, 3, 4],     // Çaylak
    [3, 4, 5],     // Yükselen
    [4, 5, 7],     // Deneyimli
    [5, 7, 9],     // Uzman
    [6, 8, 10],    // Usta
    [8, 10, 12],   // Üstat
  ];

  /// Get rank index (0-5) from ELO
  static int _getRankIndex(int elo) {
    if (elo < 200) return 0;   // Çaylak
    if (elo < 400) return 1;   // Yükselen
    if (elo < 600) return 2;   // Deneyimli
    if (elo < 800) return 3;   // Uzman
    if (elo < 1000) return 4;  // Usta
    return 5;                   // Üstat
  }

  /// Calculate new ELO after answering a question
  static int calculateNewElo({
    required int currentElo,
    required int questionDifficulty,
    required bool isCorrect,
  }) {
    final rankIndex = _getRankIndex(currentElo);
    final diffIndex = (questionDifficulty - 1).clamp(0, 2);
    
    if (isCorrect) {
      return currentElo + _correctPoints[rankIndex][diffIndex];
    } else {
      return max(0, currentElo - _wrongPoints[rankIndex][diffIndex]);
    }
  }

  /// Get difficulty level based on user ELO
  /// Returns recommended difficulty (1, 2, or 3)
  static int getRecommendedDifficulty(int userElo) {
    if (userElo < 200) return 1;       // Easy
    if (userElo < 500) return 2;       // Medium
    return 3;                          // Hard
  }

  /// Get ELO rank title
  static String getRankTitle(int elo) {
    return S.getRankName(elo);
  }

  /// Get ELO rank emoji
  static String getRankEmoji(int elo) {
    if (elo < 200) return '🌱';   // Çaylak
    if (elo < 400) return '📈';   // Yükselen
    if (elo < 600) return '💡';   // Deneyimli
    if (elo < 800) return '🎯';   // Uzman
    if (elo < 1000) return '⚡';  // Usta
    return '👑';                   // Üstat
  }

  /// Get ELO rank color (as hex string for UI)
  static int getRankColor(int elo) {
    if (elo < 200) return 0xFF795548;   // Brown - Çaylak
    if (elo < 400) return 0xFF388E3C;   // Green - Yükselen
    if (elo < 600) return 0xFFD81B60;   // Pink - Deneyimli
    if (elo < 800) return 0xFF1976D2;   // Blue - Uzman
    if (elo < 1000) return 0xFF7B1FA2;  // Purple - Usta
    return 0xFFD32F2F;                   // Red - Üstat
  }
}
