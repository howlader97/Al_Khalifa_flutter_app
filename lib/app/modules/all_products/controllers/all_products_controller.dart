import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class AllProductsController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = false.obs;
  var products = <dynamic>[].obs;
  int? sectionId;
  var title = "All Products".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      sectionId = Get.arguments['section_id'];
      title.value = Get.arguments['title'] ?? "All Products";
    }
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await _provider.getProducts(sectionId: sectionId);
      products.value = data['items'] ?? [];
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
