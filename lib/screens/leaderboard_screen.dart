import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive.dart';
import '../providers/leaderboard_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/leaderboard_tile.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaderboardProvider = context.watch<LeaderboardProvider>();
    final results = leaderboardProvider.results;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          if (results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Hapus Riwayat',
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context,
                  title: 'Hapus Riwayat Leaderboard?',
                  content:
                      'Seluruh riwayat skor yang tersimpan akan dihapus.',
                  confirmText: 'HAPUS',
                  confirmColor: Colors.red,
                );

                if (confirm) {
                  await leaderboardProvider.clearLeaderboard();
                }
              },
            ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(16.0),
            child: leaderboardProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                    ? Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 72,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum Ada Riwayat Skor',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Selesaikan kuis untuk mencatatkan skor terbaikmu di sini!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.65),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        theme.colorScheme.primary.withValues(alpha: 0.15),
                                    child: Icon(
                                      Icons.leaderboard_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Top ${results.length} Skor Tertinggi Lokal',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                final item = results[index];
                                final rank = index + 1;

                                return LeaderboardTile(
                                  rank: rank,
                                  result: item,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
