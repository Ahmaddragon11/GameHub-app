import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الصدارة'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.leaderboardEntries.isEmpty) {
            return const Center(child: Text('لا توجد بيانات في قائمة الصدارة بعد.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.leaderboardEntries.length,
              itemBuilder: (context, index) {
                final entry = controller.leaderboardEntries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(entry.username),
                    subtitle: Text('النقاط: ${entry.score} - اللعبة: ${entry.gameName}'),
                    trailing: const Icon(Icons.star),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
