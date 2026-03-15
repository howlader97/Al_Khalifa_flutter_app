import 'package:get/get.dart';
import '../../home/bindings/home_binding.dart';
import '../../cart/bindings/cart_binding.dart';
import '../../my_orders/bindings/my_orders_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../controllers/main_dashboard_controller.dart';

class MainDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainDashboardController>(() => MainDashboardController());
    
    // Inject dependencies for sub-modules
    HomeBinding().dependencies();
    CartBinding().dependencies();
    MyOrdersBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
