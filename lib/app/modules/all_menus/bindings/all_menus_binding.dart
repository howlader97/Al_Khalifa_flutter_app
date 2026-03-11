import 'package:get/get.dart';
import '../controllers/all_menus_controller.dart';

class AllMenusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllMenusController>(
      () => AllMenusController(),
    );
  }
}
