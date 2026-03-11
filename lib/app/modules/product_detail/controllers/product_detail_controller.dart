import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';

class ProductDetailController extends GetxController {
  final ProductProvider _provider = ProductProvider();
  final CartProvider _cartProvider = CartProvider();

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

  Future<void> addToCart() async {
    try {
      isLoading.value = true;
      await _cartProvider.addToCart(
        productId: product['id'],
        variationId: selectedVariationId.value,
        quantity: quantity.value,
      );
      Get.snackbar('Success', '${product['name']} added to cart',
          backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
