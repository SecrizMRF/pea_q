import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_card.dart';
import '../widgets/difficulty_chip.dart';
import '../widgets/power_up_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final quizProvider = context.read<QuizProvider>();
    final initialIndex = quizProvider.selectedCategory.index;
    _pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.88,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showProfileOptions(BuildContext context, QuizProvider quizProvider) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pengaturan Pemain: ${quizProvider.playerName}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(Icons.edit_rounded,
                        color: theme.colorScheme.primary),
                  ),
                  title: const Text('Ganti Nama'),
                  subtitle: const Text('Ubah nama pemain aktif saat ini'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showChangeNameDialog(context, quizProvider);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withValues(alpha: 0.12),
                    child: const Icon(Icons.switch_account_rounded,
                        color: Colors.orange),
                  ),
                  title: const Text('Ganti Pemain'),
                  subtitle: const Text('Kembali ke menu utama untuk ganti pemain'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppStrings.routeHome,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeNameDialog(BuildContext context, QuizProvider quizProvider) {
    final formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: quizProvider.playerName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ganti Nama Pemain'),
          content: Form(
            key: formKey,
            child: AppTextField(
              controller: nameController,
              hintText: 'Nama baru kamu',
              labelText: 'Nama Pemain Baru',
              prefixIcon: Icons.person_rounded,
              maxLength: 20,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                if (val.trim().length < 2) {
                  return 'Nama minimal 2 karakter';
                }
                if (val.trim().length > 20) {
                  return 'Nama maksimal 20 karakter';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newName = nameController.text.trim();
                  quizProvider.setPlayerName(newName);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nama berhasil diubah menjadi "$newName"'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('SIMPAN'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, ThemeData theme, QuizProvider quizProvider) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showProfileOptions(context, quizProvider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                child: Text(
                  quizProvider.playerName.isNotEmpty
                      ? quizProvider.playerName[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          quizProvider.playerName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_user_rounded,
                          size: 15,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pemain Aktif • Ketuk opsi nama/pemain',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.swap_horiz_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = context.isLandscape;
    final quizProvider = context.watch<QuizProvider>();
    final selectedCategory = quizProvider.selectedCategory;
    final selectedDifficulty = quizProvider.selectedDifficulty;
    final selectedPowerUp = quizProvider.selectedPowerUp;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_rounded),
            tooltip: 'Leaderboard Saya',
            onPressed: () {
              Navigator.of(context).pushNamed(AppStrings.routeLeaderboard);
            },
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: AppBackground(
        difficultyColor: selectedDifficulty.color,
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(16.0),
            child: isLandscape
                ? SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Profile & Category Carousel
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildProfileCard(context, theme, quizProvider),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kategori Game',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.swipe_rounded,
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Geser Kiri/Kanan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: QuizCategory.values.length,
                                  onPageChanged: (index) {
                                    quizProvider.selectCategory(
                                        QuizCategory.values[index]);
                                  },
                                  itemBuilder: (context, index) {
                                    final cat = QuizCategory.values[index];
                                    final isSelected = selectedCategory == cat;

                                    return CategoryCard(
                                      category: cat,
                                      isSelected: isSelected,
                                      onTap: () {
                                        quizProvider.selectCategory(cat);
                                        _pageController.animateToPage(
                                          index,
                                          duration: const Duration(
                                              milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    QuizCategory.values.length, (idx) {
                                  final cat = QuizCategory.values[idx];
                                  final isSelected = selectedCategory == cat;
                                  final catColor = cat.color;

                                  return GestureDetector(
                                    onTap: () {
                                      quizProvider.selectCategory(cat);
                                      _pageController.animateToPage(
                                        idx,
                                        duration: const Duration(
                                            milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      width: isSelected ? 18 : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? catColor
                                            : theme.dividerColor
                                                .withValues(alpha: 0.6),
                                        borderRadius:
                                            BorderRadius.circular(3),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Right Column: Header Title, Difficulty, Power Up, Start Button
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.tune_rounded,
                                          size: 16,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Kategori & Level Kuis',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            AppStrings.routeLeaderboard);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.leaderboard_rounded,
                                            size: 14,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Leaderboard',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tingkat Kesulitan',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: Difficulty.values.map((diff) {
                                  final isSelected = selectedDifficulty == diff;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: DifficultyChip(
                                        difficulty: diff,
                                        isSelected: isSelected,
                                        onSelected: (_) => quizProvider
                                            .selectDifficulty(diff),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Fitur Power Up',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              PowerUpCard(
                                selectedPowerUp: selectedPowerUp,
                                onTap: () => quizProvider.cyclePowerUp(),
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                onPressed: () async {
                                  await quizProvider.startQuiz();
                                  if (context.mounted) {
                                    Navigator.of(context).pushNamed(
                                        AppStrings.routeQuiz);
                                  }
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                fontSize: 16,
                                iconSize: 20,
                                icon: Icons.rocket_launch_rounded,
                                label: 'MULAI KUIS NOW',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileCard(context, theme, quizProvider),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Kategori & Level Kuis',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AppStrings.routeLeaderboard);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.leaderboard_rounded,
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Leaderboard',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategori Game',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.swipe_rounded,
                                  size: 15,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Geser Kiri/Kanan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 220,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: QuizCategory.values.length,
                            onPageChanged: (index) {
                              quizProvider
                                  .selectCategory(QuizCategory.values[index]);
                            },
                            itemBuilder: (context, index) {
                              final cat = QuizCategory.values[index];
                              final isSelected = selectedCategory == cat;

                              return CategoryCard(
                                category: cat,
                                isSelected: isSelected,
                                onTap: () {
                                  quizProvider.selectCategory(cat);
                                  _pageController.animateToPage(
                                    index,
                                    duration:
                                        const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(QuizCategory.values.length, (idx) {
                            final cat = QuizCategory.values[idx];
                            final isSelected = selectedCategory == cat;
                            final catColor = cat.color;

                            return GestureDetector(
                              onTap: () {
                                quizProvider.selectCategory(cat);
                                _pageController.animateToPage(
                                  idx,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: isSelected ? 22 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? catColor
                                      : theme.dividerColor
                                          .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Tingkat Kesulitan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: Difficulty.values.map((diff) {
                            final isSelected = selectedDifficulty == diff;
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: DifficultyChip(
                                  difficulty: diff,
                                  isSelected: isSelected,
                                  onSelected: (_) =>
                                      quizProvider.selectDifficulty(diff),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fitur Power Up',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        PowerUpCard(
                          selectedPowerUp: selectedPowerUp,
                          onTap: () {
                            quizProvider.cyclePowerUp();
                          },
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          onPressed: () async {
                            await quizProvider.startQuiz();
                            if (context.mounted) {
                              Navigator.of(context).pushNamed(AppStrings.routeQuiz);
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18),
                          fontSize: 17,
                          iconSize: 24,
                          icon: Icons.rocket_launch_rounded,
                          label: 'MULAI KUIS NOW',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
