import 'package:get/get.dart';
import '../controllers/flappy_bird_controller.dart';

class FlappyBirdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlappyBirdController>(
      () => FlappyBirdController(),
    );
  }
}
