import 'package:get/get.dart';
import '../controllers/snake_controller.dart';

class SnakeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnakeController>(
      () => SnakeController(),
      fenix: true,
    );
  }
}
