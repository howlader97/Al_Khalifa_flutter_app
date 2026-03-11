import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/delivery_area_model.dart';
import '../../../data/providers/delivery_area_provider.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();

  final cityController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final specialInstructionsController = TextEditingController();

  final selectedPaymentMethod = "Cash".obs; // Online or Cash

  final cities = <String>[].obs;
  final locations = <String>[].obs;
  final isLoadingAreas = false.obs;

  List<DeliveryAreaModel> _deliveryAreas = [];
  final _deliveryAreaProvider = DeliveryAreaProvider();

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryAreas();
  }

  Future<void> fetchDeliveryAreas() async {
    isLoadingAreas.value = true;
    try {
      _deliveryAreas = await _deliveryAreaProvider.getDeliveryAreas();
      cities.value = _deliveryAreas.map((e) => e.city).toList();
      
      if (cities.isNotEmpty) {
        // Default to Habiganj if available
        String initialCity = cities.contains("Habiganj") ? "Habiganj" : cities.first;
        setCity(initialCity);
      }
    } catch (e) {
      print("Error fetching delivery areas: $e");
    } finally {
      isLoadingAreas.value = false;
    }
  }

  void setCity(String city) {
    cityController.text = city;
    try {
      final area = _deliveryAreas.firstWhere((element) => element.city == city);
      locations.value = area.locations;
      if (locations.isNotEmpty) {
        locationController.text = locations.first;
      } else {
        locationController.text = "";
      }
    } catch (e) {
      locations.value = [];
      locationController.text = "";
    }
  }

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
