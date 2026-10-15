import 'package:flutter/material.dart';
import '../data/leaderboard_storage.dart';
import '../models/quiz_result.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardStorage _storage = LeaderboardStorage();
  List<QuizResult> _results = [];
  bool _isLoading = false;

  List<QuizResult> get results => _results;
  bool get isLoading => _isLoading;

  LeaderboardProvider() {
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    notifyListeners();

    _results = await _storage.getLeaderboard();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addResult(QuizResult result) async {
    await _storage.saveResult(result);
    await loadLeaderboard();
  }

  Future<void> clearLeaderboard() async {
    await _storage.clearLeaderboard();
    _results = [];
    notifyListeners();
  }
}
