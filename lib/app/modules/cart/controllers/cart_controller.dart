import 'package:get/get.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/providers/cart_provider.dart';

class CartController extends GetxController {
  final CartProvider cartProvider;
  CartController({required this.cartProvider});

  final isLoading = false.obs;
  final cartResponse = Rxn<CartResponse>();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      cartResponse.value = await cartProvider.getCart();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cart');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItemQuantity(int itemId, int quantity) async {
    try {
      if (quantity <= 0) {
        await cartProvider.removeItem(itemId);
      } else {
        await cartProvider.updateQuantity(itemId, quantity);
      }
      await fetchCart();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      await cartProvider.removeItem(itemId);
      await fetchCart();
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item');
    }
  }

  Future<void> addItemToCart({int? productId, int? variationId, int? partyMenuId, int quantity = 1}) async {
    try {
      isLoading.value = true;
      await cartProvider.addToCart(
        productId: productId,
        variationId: variationId,
        partyMenuId: partyMenuId,
        quantity: quantity,
      );
      Get.snackbar('Success', 'Item added to cart');
      await fetchCart();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
