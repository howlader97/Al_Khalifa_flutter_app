import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class ProductDetailController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = false.obs;
  var product = <String, dynamic>{}.obs;
  var selectedVariationId = RxnInt();
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args != null && args is Map && args.containsKey('id')) {
      final int id = args['id'];
      fetchProduct(id);
    }
  }

  Future<void> fetchProduct(int id) async {
    try {
      isLoading.value = true;
      product.value = await _provider.getProductById(id);
      // Auto-select first variation if any
      final variations = product['variations'] as List? ?? [];
      if (variations.isNotEmpty) {
        selectedVariationId.value = variations.first['id'];
      }
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  void selectVariation(int id) {
    selectedVariationId.value = id;
  }

  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  double get selectedPrice {
    final variations = product['variations'] as List? ?? [];
    if (selectedVariationId.value != null && variations.isNotEmpty) {
      final v = variations.firstWhere(
        (v) => v['id'] == selectedVariationId.value,
        orElse: () => variations.first,
      );
      return (v['price'] as num?)?.toDouble() ?? (product['price'] as num?)?.toDouble() ?? 0.0;
    }
    return (product['price'] as num?)?.toDouble() ?? 0.0;
  }
}
