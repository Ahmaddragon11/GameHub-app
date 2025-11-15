import 'package:flutter/material.dart';

class GameStatisticsCard extends StatelessWidget {
  final String gameName;
  final IconData gameIcon;
  final Color gameColor;
  final int? highScore;
  final Map<String, dynamic>? statistics;
  final VoidCallback? onTap;

  const GameStatisticsCard({
    super.key,
    required this.gameName,
    required this.gameIcon,
    required this.gameColor,
    this.highScore,
    this.statistics,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: gameColor.withOpacity(0.2),
                    child: Icon(gameIcon, color: gameColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gameName, style: theme.textTheme.titleMedium),
                        if (highScore != null)
                          Text(
                            'أعلى نتيجة: $highScore',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null) const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              if (statistics != null && statistics!.isNotEmpty) ...[
                const Divider(height: 24),
                _buildStatsDetails(context, statistics!),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsDetails(BuildContext context, Map<String, dynamic> stats) {
    final entries = stats.entries.toList();
    return Column(
      children: List.generate(entries.length, (index) {
        final entry = entries[index];
        final mode = entry.key == 'single_player' ? 'لاعب واحد' : 'لاعبان';
        final data = entry.value as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mode, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('فوز', data['wins'].toString(), Colors.green),
                  _buildStatChip('خسارة', data['losses'].toString(), Colors.red),
                  _buildStatChip('تعادل', data['draws'].toString(), Colors.grey),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.8),
        child: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
