import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../data/providers/cart_provider.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(cartProvider: CartProvider()),
    );
  }
}
