import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }
        if (controller.product.isEmpty) {
          return const Center(child: Text("Product not found"));
        }
        final product = controller.product;
        final List variations = product['variations'] as List? ?? [];

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroImage(product),
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              _buildRatingStars((product['rating'] as num?)?.toDouble() ?? 5.0, size: 18.r),
                              SizedBox(width: 8.w),
                              Text(
                                "(${(product['rating'] as num?)?.toStringAsFixed(2) ?? '5.00'}) ${product['review_count'] ?? 0} Reviews",
                                style: TextStyle(color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Obx(
                            () => Text(
                              "Tk ${controller.selectedPrice.toStringAsFixed(0)}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            product['description'] ?? 'No description available.',
                            style: TextStyle(color: Colors.black87, fontSize: 14.sp, height: 1.5),
                          ),
                          if (variations.isNotEmpty) ...[
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Variation",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8.r)),
                                  child: Text(
                                    "Required",
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Select any one",
                              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                            ),
                            SizedBox(height: 12.h),
                            Obx(
                              () => Column(
                                children: variations.map<Widget>((v) {
                                  final bool isSelected = controller.selectedVariationId.value == v['id'];
                                  final double price = (v['price'] as num?)?.toDouble() ?? 0;
                                  return GestureDetector(
                                    onTap: () => controller.selectVariation(v['id']),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 12.h),
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: isSelected ? const Color(0xFF00B14F) : Colors.grey[300]!, width: 1.5),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20.r,
                                            height: 20.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: isSelected ? const Color(0xFF00B14F) : Colors.grey[400]!, width: 2.r),
                                            ),
                                            child: isSelected
                                                ? Center(
                                                    child: Container(
                                                      width: 10.r,
                                                      height: 10.r,
                                                      decoration: const BoxDecoration(color: Color(0xFF00B14F), shape: BoxShape.circle),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Text(
                                              v['name'] ?? '',
                                              style: TextStyle(fontSize: 14.sp, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                                            ),
                                          ),
                                          Text(
                                            "Tk ${price.toStringAsFixed(0)}",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildHeroImage(Map<String, dynamic> product) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 280.h,
          child: product['image_url'] != null && product['image_url'].toString().isNotEmpty
              ? Image.network(
                  product['image_url'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 60.r, color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 60.r, color: Colors.grey),
                ),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 8.h,
          left: 16.w,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8.r)],
              ),
              child: Icon(Icons.arrow_back, size: 20.r, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 8.h,
          right: 0,
          left: 0,
          child: Center(
            child: Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h).copyWith(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12.r, offset: Offset(0, -2.h))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18.r),
                    onPressed: controller.decrementQty,
                    constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                  ),
                  Obx(
                    () => Text(
                      "${controller.quantity.value}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18.r),
                    onPressed: controller.incrementQty,
                    constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  "Add to cart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating, {double size = 12}) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: const Color(0xFFFFC107), size: size);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: const Color(0xFFFFC107), size: size);
        } else {
          return Icon(Icons.star_outline, color: Colors.grey[400], size: size);
        }
      }),
    );
  }
}
