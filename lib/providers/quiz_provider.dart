import 'dart:async';
import 'package:flutter/material.dart';
import '../data/question_repository.dart';
import '../models/enums.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';

class QuizProvider extends ChangeNotifier {
  final QuestionRepository _repository = QuestionRepository();

  String _playerName = '';
  QuizCategory _selectedCategory = QuizCategory.sejarahKonsol;
  Difficulty _selectedDifficulty = Difficulty.mudah;
  PowerUp _selectedPowerUp = PowerUp.none;
  bool _isPowerUpUsed = false;

  List<Question> _questions = [];
  int _currentIndex = 0;
  List<int?> _userAnswers = [];
  QuizStatus _status = QuizStatus.initial;

  Timer? _timer;
  int _remainingSeconds = 0;
  DateTime? _questionDeadline;

  // Getters
  String get playerName => _playerName.isEmpty ? 'Player 1' : _playerName;
  QuizCategory get selectedCategory => _selectedCategory;
  Difficulty get selectedDifficulty => _selectedDifficulty;
  PowerUp get selectedPowerUp => _selectedPowerUp;
  bool get isPowerUpUsed => _isPowerUpUsed;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  List<int?> get userAnswers => _userAnswers;
  int? get currentAnswer =>
      _userAnswers.isNotEmpty && _currentIndex < _userAnswers.length
          ? _userAnswers[_currentIndex]
          : null;

  QuizStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;

  int get totalQuestions => _questions.length;

  int get correctCount {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (i < _userAnswers.length &&
          _userAnswers[i] == _questions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  int get score {
    if (totalQuestions == 0) return 0;
    return ((correctCount / totalQuestions) * 100).round();
  }

  void setPlayerName(String name) {
    _playerName = name.trim();
    notifyListeners();
  }

  void selectCategory(QuizCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectDifficulty(Difficulty difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void selectPowerUp(PowerUp powerUp) {
    _selectedPowerUp = powerUp;
    notifyListeners();
  }

  void cyclePowerUp() {
    final nextIndex = (_selectedPowerUp.index + 1) % PowerUp.values.length;
    _selectedPowerUp = PowerUp.values[nextIndex];
    notifyListeners();
  }

  void activatePowerUp() {
    if (_isPowerUpUsed || _selectedPowerUp == PowerUp.none) return;

    _isPowerUpUsed = true;

    if (_selectedPowerUp == PowerUp.extraTime) {
      _remainingSeconds += 5;
      if (_questionDeadline != null) {
        _questionDeadline =
            _questionDeadline!.add(const Duration(seconds: 5));
      }
      notifyListeners();
    } else if (_selectedPowerUp == PowerUp.questionSlayer) {
      final currentQ = currentQuestion;
      if (currentQ != null) {
        selectAnswer(currentQ.correctIndex);
        notifyListeners();
        nextQuestion();
      }
    }
  }

  Future<void> startQuiz() async {
    _questions = await _repository.getQuestionsForQuiz(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      limit: 5,
    );

    _currentIndex = 0;
    _userAnswers = List<int?>.filled(_questions.length, null);
    _isPowerUpUsed = false;
    _status = QuizStatus.inProgress;

    _startTimerForCurrentQuestion();
    notifyListeners();
  }

  void selectAnswer(int optionIndex) {
    if (_currentIndex < _userAnswers.length) {
      _userAnswers[_currentIndex] = optionIndex;
      notifyListeners();
    }
  }

  void _startTimerForCurrentQuestion() {
    _timer?.cancel();
    _remainingSeconds = _selectedDifficulty.timerSeconds;
    _questionDeadline =
        DateTime.now().add(Duration(seconds: _remainingSeconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_questionDeadline != null) {
        final diff = _questionDeadline!.difference(DateTime.now()).inSeconds;
        _remainingSeconds = diff > 0 ? diff : 0;

        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          onTimeUp();
        } else {
          notifyListeners();
        }
      }
    });
  }

  void onTimeUp() {
    nextQuestion();
  }

  void nextQuestion() {
    _timer?.cancel();
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _startTimerForCurrentQuestion();
      notifyListeners();
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    _timer?.cancel();
    _status = QuizStatus.completed;
    notifyListeners();
  }

  QuizResult getResult() {
    return QuizResult(
      playerName: playerName,
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      score: score,
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      date: DateTime.now(),
    );
  }

  void resetQuiz() {
    _timer?.cancel();
    _currentIndex = 0;
    _questions = [];
    _userAnswers = [];
    _isPowerUpUsed = false;
    _status = QuizStatus.initial;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
