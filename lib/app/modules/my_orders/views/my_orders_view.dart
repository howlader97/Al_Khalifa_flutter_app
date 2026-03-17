import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('My Orders', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.r),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: Column(
        children: [
          _buildStatusFilters(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
              }
              if (controller.filteredOrders.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: controller.fetchOrders,
                color: const Color(0xFF00B14F),
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    final statuses = ["ALL", "PENDING", "CONFIRMED", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"];
    return Container(
      height: 60.h,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: statuses.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final status = statuses[index];
          return Obx(() {
            final isSelected = controller.selectedStatus.value == status;
            return GestureDetector(
              onTap: () => controller.filterOrders(status),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF00B14F) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                ),
                alignment: Alignment.center,
                child: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final statusColor = _getStatusColor(order['status']);
    final date = DateTime.parse(order['created_at']);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10.r, offset: Offset(0, 4.h)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order #${order['id']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(color: statusColor, fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(formattedDate, style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
                  Divider(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${(order['items'] as List).length} Items", style: TextStyle(color: Colors.grey[600], fontSize: 13.sp)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Total: ", style: TextStyle(fontSize: 14.sp)),
                              Text("৳${order['total']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: const Color(0xFF00B14F))),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => Get.toNamed('/order-details', arguments: {'order': order}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B14F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        ),
                        child: Text("See Details", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text("No orders found", style: TextStyle(color: Colors.grey[600], fontSize: 16.sp)),
          SizedBox(height: 8.h),
          Text("Place your first order now!", style: TextStyle(color: Colors.grey[400], fontSize: 12.sp)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING': return Colors.orange;
      case 'CONFIRMED': return Colors.blue;
      case 'PROCESSING': return Colors.indigo;
      case 'SHIPPED': return Colors.purple;
      case 'DELIVERED': return Colors.green;
      case 'CANCELLED': return Colors.red;
      default: return Colors.grey;
    }
  }
}
