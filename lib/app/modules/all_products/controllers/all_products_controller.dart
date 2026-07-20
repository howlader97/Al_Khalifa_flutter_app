import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class AllProductsController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = false.obs;
  var products = <dynamic>[].obs;
  int? sectionId;
  var title = "All Products".obs;

  Future<void> onAppInitial() async {
    try {
      if (Get.arguments is Map) {
        sectionId = Get.arguments['section_id'];
        title.value = Get.arguments['title'] ?? "All Products";
      }
      fetchProducts();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInitial();
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
