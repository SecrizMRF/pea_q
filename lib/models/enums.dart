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

enum PowerUp {
  none(
    keyName: 'none',
    label: 'Tanpa Power Up',
    description: 'Bermain murni tanpa bantuan',
    icon: Icons.block_rounded,
    color: Colors.grey,
  ),
  extraTime(
    keyName: 'extraTime',
    label: 'Extra Time (+5s)',
    description: 'Memberikan tambahan waktu 5 detik',
    icon: Icons.more_time_rounded,
    color: Colors.blue,
  ),
  questionSlayer(
    keyName: 'questionSlayer',
    label: 'Question Slayer',
    description: 'Otomatis menjawab benar & lewati 1 soal',
    icon: Icons.auto_awesome_rounded,
    color: Colors.amber,
  );

  final String keyName;
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const PowerUp({
    required this.keyName,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  static PowerUp fromKey(String key) {
    return PowerUp.values.firstWhere(
      (e) => e.keyName == key,
      orElse: () => PowerUp.none,
    );
  }
}

enum QuizStatus {
  initial,
  inProgress,
  completed,
}
