import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_strings.dart';
import '../models/quiz_result.dart';

class LeaderboardStorage {
  Future<List<QuizResult>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppStrings.prefLeaderboard);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final results = jsonList.map((e) => QuizResult.fromJson(e)).toList();
      results.sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;
        return b.date.compareTo(a.date);
      });
      return results;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveResult(QuizResult result) async {
    final results = await getLeaderboard();
    results.add(result);

    results.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return b.date.compareTo(a.date);
    });

    final topResults = results.take(20).toList();
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(topResults.map((r) => r.toJson()).toList());
    await prefs.setString(AppStrings.prefLeaderboard, jsonString);
  }

  Future<void> clearLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.prefLeaderboard);
  }
}
