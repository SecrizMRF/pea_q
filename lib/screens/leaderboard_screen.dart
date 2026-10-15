import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../core/utils/responsive.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaderboardProvider = context.watch<LeaderboardProvider>();
    final results = leaderboardProvider.results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          if (results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Hapus Riwayat',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Hapus Riwayat Leaderboard?'),
                    content: const Text(
                        'Seluruh riwayat skor yang tersimpan akan dihapus.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('BATAL'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('HAPUS'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await leaderboardProvider.clearLeaderboard();
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(16.0),
          child: leaderboardProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 80,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum Ada Riwayat Skor',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selesaikan kuis untuk mencatatkan skor di sini!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        final rank = index + 1;

                        Widget rankBadge;
                        if (rank == 1) {
                          rankBadge = const Text('🥇', style: TextStyle(fontSize: 24));
                        } else if (rank == 2) {
                          rankBadge = const Text('🥈', style: TextStyle(fontSize: 24));
                        } else if (rank == 3) {
                          rankBadge = const Text('🥉', style: TextStyle(fontSize: 24));
                        } else {
                          rankBadge = CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              '#$rank',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: rankBadge,
                            title: Text(
                              item.playerName,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              '${item.category.label} • ${item.difficulty.label}\n${AppFormatters.formatDate(item.date)}',
                              style: AppTextStyles.caption(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            trailing: Text(
                              AppFormatters.formatScore(item.score),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
