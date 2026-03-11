import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';

class MenuDetailController extends GetxController {
  final ProductProvider _provider = ProductProvider();
  final CartProvider _cartProvider = CartProvider();

  var isLoading = false.obs;
  var menu = <String, dynamic>{}.obs;
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args != null && args is Map && args.containsKey('id')) {
      final int id = args['id'];
      fetchMenu(id);
    }
  }

  Future<void> fetchMenu(int id) async {
    try {
      isLoading.value = true;
      menu.value = await _provider.getPartyMenuById(id);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  Future<void> addToCart() async {
    try {
      isLoading.value = true;
      await _cartProvider.addToCart(
        partyMenuId: menu['id'],
        quantity: quantity.value,
      );
      Get.snackbar('Success', '${menu['title']} added to cart',
          backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
