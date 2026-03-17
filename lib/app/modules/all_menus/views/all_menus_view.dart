import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_menus_controller.dart';

class AllMenusView extends GetView<AllMenusController> {
  const AllMenusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Special Menus",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }
        if (controller.menus.isEmpty) {
          return const Center(child: Text("No menus found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.menus.length,
          itemBuilder: (context, index) {
            final menu = controller.menus[index];
            return _buildMenuCard(context, menu);
          },
        );
      }),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> menu) {
    final String imageUrl = menu['image_url'] as String? ?? '';
    final String title = menu['title'] as String? ?? '';
    final String description = menu['description'] as String? ?? 'Delicious meal prepared just for you.';
    final double price = (menu['price'] as num?)?.toDouble() ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.MENU_DETAIL,
        arguments: {'id': menu['id']},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[100],
                          child: const Icon(Icons.restaurant, color: Colors.grey, size: 50),
                        ),
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: const Icon(Icons.restaurant, color: Colors.grey, size: 50),
                      ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B14F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Tk ${price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildRatingStars((menu['rating'] as num?)?.toDouble() ?? 5.0, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "(${(menu['review_count'] ?? 0)})",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildTag(Icons.timer_outlined, "20-30 min"),
                    const SizedBox(width: 12),
                    _buildTag(Icons.delivery_dining_outlined, "Free Delivery"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
