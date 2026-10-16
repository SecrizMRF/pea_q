import 'package:flutter/material.dart';

enum QuizCategory {
  sejarahKonsol(
    keyName: 'sejarahKonsol',
    label: 'Sejarah & Konsol',
    description: 'Fakta unik sejarah konsol & perkembangan industri game',
    icon: Icons.sports_esports_rounded,
    color: Color(0xFF8E24AA), // Purple / Magenta
  ),
  genreMekanik(
    keyName: 'genreMekanik',
    label: 'Genre & Mekanik',
    description: 'Istilah, logika, dan mekanisme permainan',
    icon: Icons.extension_rounded,
    color: Color(0xFF00897B), // Teal / Emerald
  ),
  karakterDunia(
    keyName: 'karakterDunia',
    label: 'Karakter & Dunia',
    description: 'Karakter ikonik, lore, dan dunia video game',
    icon: Icons.person_search_rounded,
    color: Color(0xFFE65100), // Deep Orange
  ),
  esports(
    keyName: 'esports',
    label: 'Esports & Kompetitif',
    description: 'Turnamen, atlet, dan momen bersejarah esports',
    icon: Icons.emoji_events_rounded,
    color: Color(0xFF1E88E5), // Cobalt Blue
  );

  final String keyName;
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const QuizCategory({
    required this.keyName,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  static QuizCategory fromKey(String key) {
    return QuizCategory.values.firstWhere(
      (e) => e.keyName == key,
      orElse: () => QuizCategory.sejarahKonsol,
    );
  }
}

enum Difficulty {
  mudah(
    keyName: 'mudah',
    label: 'Mudah',
    timerSeconds: 30,
    color: Colors.green,
  ),
  sedang(
    keyName: 'sedang',
    label: 'Sedang',
    timerSeconds: 20,
    color: Colors.orange,
  ),
  sulit(
    keyName: 'sulit',
    label: 'Sulit',
    timerSeconds: 15,
    color: Colors.red,
  );

  final String keyName;
  final String label;
  final int timerSeconds;
  final Color color;

  const Difficulty({
    required this.keyName,
    required this.label,
    required this.timerSeconds,
    required this.color,
  });

  static Difficulty fromKey(String key) {
    return Difficulty.values.firstWhere(
      (e) => e.keyName == key,
      orElse: () => Difficulty.mudah,
    );
  }
}

enum QuizStatus {
  initial,
  inProgress,
  completed,
}
