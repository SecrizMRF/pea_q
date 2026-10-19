import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/app_text_field.dart';
import '../widgets/peaqook_logo.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final currentName = context.read<QuizProvider>().playerName;
    _nameController =
        TextEditingController(text: currentName == 'Player 1' ? '' : currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      context
          .read<QuizProvider>()
          .setPlayerName(name.isEmpty ? 'Player 1' : name);
      Navigator.of(context).pushNamed(AppStrings.routeCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Siluet Logo Merak Bulat PeaQook
                    Center(
                      child: PeaQookLogo(
                        size: context.sw(22).clamp(80, 120),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selamat Datang di PeaQook! 🦚',
                      style: theme.textTheme.displayLarge?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uji pengetahuanmu seputar dunia video game!',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: _nameController,
                              labelText: 'Nama Pemain',
                              hintText: 'Ketik nama kamu (mis. RedPlayer)',
                              prefixIcon: Icons.person_rounded,
                              maxLength: 20,
                              onChanged: (text) {
                                context
                                    .read<QuizProvider>()
                                    .setPlayerName(text.trim());
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                if (value.trim().length < 2) {
                                  return 'Nama minimal 2 karakter';
                                }
                                if (value.trim().length > 20) {
                                  return 'Nama maksimal 20 karakter';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: _onStartPressed,
                      label: 'MULAI KUIS',
                      icon: Icons.play_arrow_rounded,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppStrings.routeLeaderboard);
                      },
                      icon: const Icon(Icons.leaderboard_rounded),
                      label: const Text('LEADERBOARD'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
