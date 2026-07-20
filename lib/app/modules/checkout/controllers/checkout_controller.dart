import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/delivery_area_model.dart';
import '../../../data/providers/delivery_area_provider.dart';
import '../../../data/providers/delivery_fee_provider.dart';
import '../../../data/providers/order_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/payment_provider.dart';
import '../../../routes/app_pages.dart';
import '../views/ssl_commerz_webview.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();

  final cityController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final specialInstructionsController = TextEditingController();
  final phoneController = TextEditingController();

  final selectedPaymentMethod = "Cash".obs; // Online or Cash

  final cities = <String>[].obs;
  final locations = <String>[].obs;
  final isLoadingAreas = false.obs;

  List<DeliveryAreaModel> _deliveryAreas = [];
  final _deliveryAreaProvider = DeliveryAreaProvider();
  final _deliveryFeeProvider = DeliveryFeeProvider();
  final _orderProvider = OrderProvider();
  final _paymentProvider = PaymentProvider();
  final _storage = GetStorage();

  final dynamicDeliveryFee = 0.0.obs;
  final isLoadingFee = false.obs;
  final isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryAreas();
    fetchDeliveryFee();
  }

  Future<void> fetchDeliveryFee() async {
    isLoadingFee.value = true;
    try {
      dynamicDeliveryFee.value = await _deliveryFeeProvider.getLatestDeliveryFee();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoadingFee.value = false;
    }
  }

  Future<void> fetchDeliveryAreas() async {
    isLoadingAreas.value = true;
    try {
      _deliveryAreas = await _deliveryAreaProvider.getDeliveryAreas();
      var data = await _deliveryAreaProvider.getDeliveryAreas();
      if (kDebugMode) debugPrint(data.toString());
      cities.value = _deliveryAreas.map((e) => e.city).toList();

      if (cities.isNotEmpty) {
        // Default to Habiganj if available
        String initialCity = cities.contains("Habiganj") ? "Habiganj" : cities.first;
        setCity(initialCity);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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
  double get deliveryFee => dynamicDeliveryFee.value > 0 ? dynamicDeliveryFee.value : (cart?.shipping ?? 0.0);
  double get total => subtotal + deliveryFee;

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> processCheckout() async {
    if (addressController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your full address", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (cityController.text.isEmpty || locationController.text.isEmpty) {
      Get.snackbar("Error", "Please select City and Location", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your phone number", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final token = _storage.read('access_token');
    if (token == null) {
      Get.snackbar("Error", "Session expired. Please login again.", backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAllNamed('/login');
      return;
    }

    isPlacingOrder.value = true;
    try {
      final orderData = {
        "city": cityController.text,
        "location": locationController.text,
        "address": addressController.text,
        "special_instruction": specialInstructionsController.text.isEmpty ? null : specialInstructionsController.text,
        "phone_number": phoneController.text,
        "payment_method": selectedPaymentMethod.value,
      };

      final order = await _orderProvider.placeOrder(orderData, token);

      if (selectedPaymentMethod.value == "Digital Payment") {
        final paymentUrl = await _paymentProvider.initiatePayment(order['id'], token);
        if (paymentUrl != null) {
          Get.to(
            () => SSLCommerzWebView(
              paymentUrl: paymentUrl,
              onPaymentSuccess: () async {
                // Payment succeeded — cart is cleared on backend. Refresh & go home.
                await cartController.fetchCart();
                Get.offAllNamed(Routes.MAIN_DASHBOARD);
                Get.snackbar("Success", "Payment Successful!", backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
              },
              onPaymentFailed: () {
                // Payment failed — cart is still intact on backend. Stay on checkout.
                Get.back(); // go back to checkout screen
                Get.snackbar("Payment Failed", "Payment was not successful. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
              },
              onPaymentCancelled: () {
                // Payment cancelled — cart is still intact on backend. Stay on checkout.
                Get.back(); // go back to checkout screen
                Get.snackbar(
                  "Payment Cancelled",
                  "You cancelled the payment. Your cart is still saved.",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
            ),
          );
          return;
        }
      }

      // Cash payment — cart already cleared on backend, refetch and go home.
      await cartController.fetchCart();
      Get.snackbar("Success", "Order placed successfully!", backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
      Get.offAllNamed(Routes.MAIN_DASHBOARD);
    } catch (e) {
      Get.snackbar("Order Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
