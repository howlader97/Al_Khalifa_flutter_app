import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_detail_controller.dart';

class MenuDetailView extends GetView<MenuDetailController> {
  const MenuDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }
        if (controller.menu.isEmpty) {
          return const Center(child: Text("Menu not found"));
        }
        final menu = controller.menu;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroImage(menu),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildRatingStars((menu['rating'] as num?)?.toDouble() ?? 5.0, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "(${(menu['rating'] as num?)?.toStringAsFixed(1) ?? '5.0'}) ${menu['review_count'] ?? 0} Reviews", 
                                style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),

                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Tk ${((menu['price'] as num?)?.toDouble() ?? 0).toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFF00B14F),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Description",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            menu['description'] ?? 'No description available.',
                            style: TextStyle(color: Colors.grey[700], fontSize: 15, height: 1.6),
                          ),
                          const SizedBox(height: 24),
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

  Widget _buildHeroImage(Map<String, dynamic> menu) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          child: menu['image_url'] != null && menu['image_url'].toString().isNotEmpty
              ? Image.network(
                  menu['image_url'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.grey[100],
                  child: const Icon(Icons.restaurant, size: 80, color: Colors.grey)),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 12,
          left: 16,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 10)],
              ),
              child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: controller.decrementQty,
                  ),
                  Obx(() => Text(
                    "${controller.quantity.value}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: controller.incrementQty,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B14F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
