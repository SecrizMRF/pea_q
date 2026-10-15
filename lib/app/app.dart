import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PixelQuizApp extends StatelessWidget {
  const PixelQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppStrings.routeSplash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
