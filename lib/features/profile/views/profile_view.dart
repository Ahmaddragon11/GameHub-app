import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/profile/controllers/profile_controller.dart';
import 'package:myapp/features/profile/widgets/game_statistics_card.dart';
import 'package:myapp/features/profile/widgets/stat_card.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.user.value == null) {
            return const Center(child: Text('لا يمكن تحميل بيانات المستخدم'));
          }

          final user = controller.user.value!;

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, user),
                _buildQuickStats(context),
                _buildGamesStatistics(context),
                _buildActions(context, user.isGuest),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context, dynamic user) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.surface,
              child: Text(
                user.displayName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.displayName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!user.isGuest)
              Text(
                user.email ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            if (user.isGuest)
              Chip(
                label: const Text('ضيف'),
                backgroundColor: theme.colorScheme.secondary,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            const SizedBox(height: 8),
            Text(
              'تاريخ الانضمام: ${DateFormat.yMMMd('ar').format(user.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildQuickStats(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.play_circle_outline,
                value: controller.totalGamesPlayed.value.toString(),
                label: 'إجمالي الألعاب',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events_outlined,
                value: controller.totalWins.toString(),
                label: 'إجمالي الانتصارات',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                icon: Icons.star_border_outlined,
                value: '${controller.winRate.toStringAsFixed(1)}%',
                label: 'نسبة الفوز',
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildGamesStatistics(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات الألعاب',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GameStatisticsCard(
              gameName: 'Snake',
              gameIcon: Icons.turn_right,
              gameColor: Colors.lightGreen,
              highScore: controller.snakeHighScore.value,
            ),
            const SizedBox(height: 12),
            GameStatisticsCard(
              gameName: 'Flappy Bird',
              gameIcon: Icons.flight,
              gameColor: Colors.lightBlue,
              highScore: controller.flappyBirdHighScore.value,
            ),
            const SizedBox(height: 12),
            GameStatisticsCard(
              gameName: 'Tic Tac Toe',
              gameIcon: Icons.close,
              gameColor: Colors.redAccent,
              statistics: controller.ticTacToeStats,
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildActions(BuildContext context, bool isGuest) {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: isGuest
            ? ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('سجل الآن لحفظ تقدمك'),
                onPressed: controller.navigateToAuth,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            : OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                onPressed: () => Get.defaultDialog(
                  title: 'تأكيد',
                  middleText: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                  textConfirm: 'نعم',
                  textCancel: 'لا',
                  onConfirm: controller.logout,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
      ),
    );
  }
}
