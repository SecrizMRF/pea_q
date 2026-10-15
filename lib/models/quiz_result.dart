import 'enums.dart';

class QuizResult {
  final String playerName;
  final QuizCategory category;
  final Difficulty difficulty;
  final int score;
  final int correctCount;
  final int totalQuestions;
  final DateTime date;

  const QuizResult({
    required this.playerName,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.date,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      playerName: json['playerName'] as String,
      category: QuizCategory.fromKey(json['category'] as String),
      difficulty: Difficulty.fromKey(json['difficulty'] as String),
      score: json['score'] as int,
      correctCount: json['correctCount'] as int,
      totalQuestions: json['totalQuestions'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'category': category.keyName,
      'difficulty': difficulty.keyName,
      'score': score,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
    };
  }
}
