import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/order_provider.dart';

class MyOrdersController extends GetxController {
  final OrderProvider _orderProvider = OrderProvider();
  final _storage = GetStorage();

  var orders = [].obs;
  var filteredOrders = [].obs;
  var isLoading = false.obs;
  var selectedStatus = "ALL".obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final token = _storage.read('access_token');
      if (token == null) {
        Get.snackbar("Error", "Please login to see your orders", 
          backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final fetchedOrders = await _orderProvider.getMyOrders(token);
      orders.value = fetchedOrders;
      filterOrders(selectedStatus.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: ${e.toString()}', 
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders(String status) {
    selectedStatus.value = status;
    if (status == "ALL") {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((order) => order['status'] == status).toList();
    }
  }
}
