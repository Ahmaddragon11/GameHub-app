import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/game_card.dart';
import '../../../shared/widgets/custom_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الألعاب الكلاسيكية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () { // Placeholder for notifications
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.games.length,
                  itemBuilder: (context, index) {
                    final game = controller.games[index];
                    return GameCard(
                      game: game,
                      onTap: () => controller.navigateToGame(game.route),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      // Optional FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Navigate to a global leaderboard or chat
          Get.toNamed('/leaderboard');
        },
        child: const Icon(Icons.leaderboard),
      ),
    );
  }
}
