import 'package:get/get.dart';
import '../controllers/tic_tac_toe_controller.dart';

class TicTacToeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicTacToeController>(
      () => TicTacToeController(),
    );
  }
}
