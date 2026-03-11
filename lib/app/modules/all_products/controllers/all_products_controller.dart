import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class AllProductsController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = false.obs;
  var products = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await _provider.getProducts();
      products.value = data['items'] ?? [];
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
