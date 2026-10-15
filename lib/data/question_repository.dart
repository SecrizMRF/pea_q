import 'dart:convert';
import 'package:flutter/services.dart';
import '../core/constants/app_assets.dart';
import '../models/enums.dart';
import '../models/question.dart';

class QuestionRepository {
  List<Question> _allQuestions = [];

  Future<List<Question>> loadQuestions() async {
    if (_allQuestions.isNotEmpty) return _allQuestions;

    final jsonString = await rootBundle.loadString(AppAssets.questionsJson);
    final List<dynamic> jsonList = json.decode(jsonString);
    _allQuestions = jsonList.map((q) => Question.fromJson(q)).toList();
    return _allQuestions;
  }

  Future<List<Question>> getQuestionsForQuiz({
    required QuizCategory category,
    required Difficulty difficulty,
    int limit = 5,
  }) async {
    final all = await loadQuestions();
    final filtered = all
        .where((q) => q.category == category && q.difficulty == difficulty)
        .toList();

    filtered.shuffle();
    if (filtered.length > limit) {
      return filtered.sublist(0, limit);
    }
    return filtered;
  }
}
