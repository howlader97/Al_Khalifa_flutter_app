import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text('Order Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.r),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final order = controller.order.value;
        if (order == null) {
          return const Center(child: Text("Order details not found."));
        }

        final statusColor = _getStatusColor(order['status']);
        final date = DateTime.parse(order['created_at']);
        final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #${order['id']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(color: statusColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.r, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(formattedDate, style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Items Section
              _buildSectionTitle("Items Ordered"),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    ...(order['items'] as List).map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: item['image_url'] != null && item['image_url'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.network(
                                      item['image_url'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                          Icon(Icons.restaurant_menu, color: const Color(0xFF00B14F), size: 24.r),
                                    ),
                                  )
                                : Icon(Icons.restaurant_menu, color: const Color(0xFF00B14F), size: 24.r),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                Text("Qty: ${item['quantity']} x ৳${item['price']}", style: TextStyle(color: Colors.grey[600], fontSize: 13.sp)),
                              ],
                            ),
                          ),
                          Text("৳${item['price'] * item['quantity']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Delivery Info
              _buildSectionTitle("Delivery Details"),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.location_on_outlined, "Area", "${order['city']}, ${order['location']}"),
                    Divider(height: 24.h),
                    _buildInfoRow(Icons.home_outlined, "Address", order['address']),
                    Divider(height: 24.h),
                    _buildInfoRow(Icons.phone_outlined, "Phone", order['phone_number'] ?? 'N/A'),
                    if (order['special_instruction'] != null && order['special_instruction'].isNotEmpty) ...[
                      Divider(height: 24.h),
                      _buildInfoRow(Icons.note_alt_outlined, "Instruction", order['special_instruction']),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Summary
              _buildSectionTitle("Payment Summary"),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("Subtotal", "৳${order['subtotal']}"),
                    SizedBox(height: 12.h),
                    _buildSummaryRow("Delivery Fee", "৳${order['delivery_fee']}"),
                    Divider(height: 24.h),
                    _buildSummaryRow("Total Amount", "৳${order['total']}", isTotal: true),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Payment Method", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                        Text(order['payment_method'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rating Section (Conditional)
              if (order['status'] == 'DELIVERED' && order['review'] == null) ...[
                _buildRatingSection(),
                const SizedBox(height: 24),
              ],
              
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 20.r, offset: Offset(0, 8.h)),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Did you like the food!",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 8.h),
          Text(
            "Please rate this food so, that we can improve it!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey, height: 1.5),
          ),
          SizedBox(height: 24.h),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => controller.rating.value = index + 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    controller.rating.value >= index + 1 ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFB800),
                    size: 40.r,
                  ),
                ),
              );
            }),
          )),
          SizedBox(height: 24.h),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : () => controller.submitReview(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D2C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: controller.isSubmitting.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("Rate", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.r, color: const Color(0xFF00B14F)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              SizedBox(height: 2.h),
              Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey, fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: isTotal ? const Color(0xFF00B14F) : Colors.black, fontSize: isTotal ? 20.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
      ],
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
