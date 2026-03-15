import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routes/app_pages.dart';
import '../controllers/cart_controller.dart';
import '../../../data/models/cart_model.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyActions: false,
        title: Text(
          "My Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        leading: Navigator.of(context).canPop() 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ) 
            : null,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cartResponse.value == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }

        final cart = controller.cartResponse.value;
        if (cart == null || cart.items.isEmpty) {
          return _buildEmptyCart();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchCart(),
          color: const Color(0xFF00B14F),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(cart.items[index]);
                  },
                ),
              ),
              _buildOrderSummary(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            "Your cart is empty",
            style: TextStyle(color: Colors.grey[600], fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B14F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: Text("Go Shopping", style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    final String title = item.partyMenu != null 
        ? item.partyMenu!['title'] 
        : (item.product != null ? item.product!['name'] : 'Unknown Item');
    
    final String? imageUrl = item.partyMenu != null 
        ? item.partyMenu!['image_url'] 
        : (item.product != null ? item.product!['image_url'] : null);
        
    final double price = item.variation != null 
        ? (item.variation!['price'] as num).toDouble() 
        : (item.partyMenu != null ? (item.partyMenu!['price'] as num).toDouble() : 0.0);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80.w,
                      height: 80.w,
                      color: Colors.grey[100],
                      child: Icon(Icons.fastfood, color: Colors.grey, size: 30.r),
                    ),
                  )
                : Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.grey[100],
                    child: Icon(Icons.fastfood, color: Colors.grey, size: 30.r),
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variation != null)
                  Text(
                    item.variation!['name'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                  ),
                SizedBox(height: 8.h),
                Text(
                  "Tk ${price.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: const Color(0xFF00B14F),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.r),
                onPressed: () => controller.removeItem(item.id),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    _buildQtyBtn(Icons.remove, () => controller.updateItemQuantity(item.id, item.quantity - 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "${item.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildQtyBtn(Icons.add, () => controller.updateItemQuantity(item.id, item.quantity + 1)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Icon(icon, size: 16.r, color: Colors.black87),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Obx(() => _buildSummaryRow("Subtotal", "Tk ${controller.subtotal.toStringAsFixed(0)}")),
            SizedBox(height: 8.h),
            Obx(() => _buildSummaryRow("Delivery Charge", "Tk ${controller.deliveryFee.toStringAsFixed(0)}")),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Divider(),
            ),
            Obx(() => _buildSummaryRow(
              "Total", 
              "Tk ${controller.total.toStringAsFixed(0)}", 
              isTotal: true
            )),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.CHECKOUT),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18.sp : 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF00B14F) : Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 20.sp : 15.sp,
          ),
        ),
      ],
    );
  }
}
