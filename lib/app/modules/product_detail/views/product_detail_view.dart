import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                              const SizedBox(width: 4),
                              const Text("(5.00)", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(() => Text(
                            "Tk ${controller.selectedPrice.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          )),
                          const SizedBox(height: 12),
                          Text(
                            product['description'] ?? 'No description available.',
                            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                          ),
                          if (variations.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Variation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text("Required", style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                              ],
                            ),
                            const Text(
                              "Select any one",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            Obx(() => Column(
                              children: variations.map<Widget>((v) {
                                final bool isSelected = controller.selectedVariationId.value == v['id'];
                                final double price = (v['price'] as num?)?.toDouble() ?? 0;
                                return GestureDetector(
                                  onTap: () => controller.selectVariation(v['id']),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF00B14F) : Colors.grey[300]!,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF00B14F) : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Center(
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF00B14F),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            v['name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Tk ${price.toStringAsFixed(0)}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
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
          height: 280,
          child: product['image_url'] != null &&
                  product['image_url'].toString().isNotEmpty
              ? Image.network(
                  product['image_url'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey)),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 8,
          left: 16,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 8,
          right: 0,
          left: 0,
          child: const Center(
            child: Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          // Quantity
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: controller.decrementQty,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Obx(() => Text(
                  "${controller.quantity.value}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: controller.incrementQty,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar("Cart", "${controller.product['name']} added to cart!", backgroundColor: const Color(0xFF00B14F), colorText: Colors.white);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B14F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Add to cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
