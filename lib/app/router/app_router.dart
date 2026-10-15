import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../screens/category_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/leaderboard_screen.dart';
import '../../screens/quiz_screen.dart';
import '../../screens/result_screen.dart';
import '../../screens/review_screen.dart';
import '../../screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppStrings.routeSplash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppStrings.routeHome:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppStrings.routeCategory:
        return MaterialPageRoute(
          builder: (_) => const CategoryScreen(),
          settings: settings,
        );
      case AppStrings.routeQuiz:
        return MaterialPageRoute(
          builder: (_) => const QuizScreen(),
          settings: settings,
        );
      case AppStrings.routeResult:
        return MaterialPageRoute(
          builder: (_) => const ResultScreen(),
          settings: settings,
        );
      case AppStrings.routeReview:
        return MaterialPageRoute(
          builder: (_) => const ReviewScreen(),
          settings: settings,
        );
      case AppStrings.routeLeaderboard:
        return MaterialPageRoute(
          builder: (_) => const LeaderboardScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
