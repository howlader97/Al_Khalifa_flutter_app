import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/cart_model.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();

  final districtController = TextEditingController(text: "Dhaka");
  final cityController = TextEditingController(text: "Dhaka");
  final addressController = TextEditingController();
  final specialInstructionsController = TextEditingController();

  final selectedPaymentMethod = "Cash".obs; // Online or Cash

  final districts = ["Dhaka", "Chittagong", "Sylhet", "Rajshahi", "Khulna", "Barisal", "Rangpur", "Mymensingh"].obs;
  final cities = ["Dhaka", "Gazipur", "Narayanganj", "Savar"].obs;

  CartResponse? get cart => cartController.cartResponse.value;

  double get subtotal => cart?.subtotal ?? 0.0;
  double get deliveryFee => cart?.shipping ?? 0.0;
  double get total => subtotal + deliveryFee;

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void processCheckout() {
    if (addressController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your full address",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    // Logic for placing order would go here
    Get.snackbar("Success", "Order placed successfully!",
        backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
    
    // Clear cart or navigate to success screen
  }
}
