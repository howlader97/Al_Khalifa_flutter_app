import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../my_orders/controllers/my_orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainDashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    _refreshTabData(index);
  }

  void _refreshTabData(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchAll();
        }
        break;
      case 1:
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().fetchCart();
        }
        break;
      case 2:
        if (Get.isRegistered<MyOrdersController>()) {
          Get.find<MyOrdersController>().fetchOrders();
        }
        break;
      case 3:
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().loadUserProfile();
        }
        break;
    }
  }
}
