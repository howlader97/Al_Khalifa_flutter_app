import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/order_provider.dart';

class OrderDetailsController extends GetxController {
  final OrderProvider _orderProvider = OrderProvider();
  final _storage = GetStorage();
  
  final order = Rxn<Map<String, dynamic>>();
  var rating = 5.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['order'] != null) {
      order.value = Get.arguments['order'];
    }
  }

  Future<void> submitReview() async {
    if (order.value == null) return;
    
    try {
      isSubmitting.value = true;
      final token = _storage.read('access_token');
      final reviewData = {
        'order_id': order.value!['id'],
        'rating': rating.value,
        'comment': '',
      };
      
      await _orderProvider.submitReview(reviewData, token);
      
      // Update local state to hide review section
      final updatedOrder = Map<String, dynamic>.from(order.value!);
      updatedOrder['review'] = {'rating': rating.value}; 
      order.value = updatedOrder;

      Get.snackbar("Success", "Thank you for your review!", 
        backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), 
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }
}
