import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../product_detail/views/product_detail_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildPromoBanner(),
                    const SizedBox(height: 24),
                    _buildSectionHeader("Our Cuisines", onSeeAll: () => Get.toNamed(Routes.ALL_MENUS)),
                    const SizedBox(height: 12),
                    _buildCategoryList(),
                    const SizedBox(height: 24),
                    _buildSectionHeader("Popular", onSeeAll: () => Get.toNamed(Routes.ALL_PRODUCTS)),
                    const SizedBox(height: 12),
                    _buildProductGrid(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader("Meal For One",
                        subtitle: "Delivery fee included!", onSeeAll: () => Get.toNamed(Routes.ALL_MENUS)),
                    const SizedBox(height: 12),
                    _buildPartyMenuList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Color(0xFF00B14F), size: 18),
              SizedBox(width: 4),
              Text("Nurpur Union",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
            ],
          ),
          IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: "Search for food",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF00B14F),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Share the love",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85), fontSize: 12)),
                const SizedBox(height: 8),
                const Text(
                  "Enjoy\nDiscount Food",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      height: 1.2),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(Icons.lunch_dining,
                  size: 80, color: Colors.white.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {String? subtitle, VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              if (subtitle != null)
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text("See All",
                style: TextStyle(
                    color: Color(0xFF00B14F),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ---- Our Cuisines: uses /party-menu API ----
  Widget _buildCategoryList() {
    return Obx(() {
      if (controller.isLoadingMenus.value) {
        return const SizedBox(
            height: 105,
            child: Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF00B14F))));
      }
      final menus = controller.partyMenus;
      if (menus.isEmpty) {
        return const SizedBox(
            height: 105,
            child: Center(
                child: Text("No cuisines",
                    style: TextStyle(color: Colors.grey, fontSize: 13))));
      }
      return SizedBox(
        height: 105,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: menus.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final menu = menus[index]; // fields: id, title, image_url
            final imageUrl = menu['image_url'] as String? ?? '';
            final title = menu['title'] as String? ?? '';
            return SizedBox(
              width: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8)
                        ],
                      ),
                      child: imageUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.restaurant_menu,
                                        color: Color(0xFF00B14F), size: 24),
                              ),
                            )
                          : const Icon(Icons.restaurant_menu,
                              color: Color(0xFF00B14F), size: 24),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black87),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  // ---- Popular: uses /products/ API ----
  Widget _buildProductGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingProducts.value) {
        return const SizedBox(
            height: 100,
            child: Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF00B14F))));
      }
      final items = controller.filteredProducts.take(6).toList();
      if (items.isEmpty) {
        return const SizedBox(
            height: 80,
            child: Center(
                child: Text("No products",
                    style: TextStyle(color: Colors.grey, fontSize: 13))));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildProductCard(context, items[index]);
          },
        ),
      );
    });
  }

  Widget _buildProductCard(
      BuildContext context, Map<String, dynamic> product) {
    // Product fields: id, name, description, image_url, category_id, variations[{id, name, price}]
    final String imageUrl = product['image_url'] as String? ?? '';
    final String name = product['name'] as String? ?? '';
    // Price comes from first variation or fallback
    final List variations = product['variations'] as List? ?? [];
    final double price = variations.isNotEmpty
        ? (variations.first['price'] as num?)?.toDouble() ?? 0
        : 0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.PRODUCT_DETAIL,
        arguments: {'id': product['id']},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 140,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        )
                      : Container(
                          height: 140,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey)),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Color(0xFF00B14F),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 14),
                      Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 14),
                      Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 14),
                      Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 14),
                      Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 14),
                      SizedBox(width: 2),
                      Text(" (5.00)",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tk ${price.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Meal For One: uses /party-menu API ----
  Widget _buildPartyMenuList(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMenus.value) {
        return const SizedBox(
            height: 100,
            child: Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF00B14F))));
      }
      final menus = controller.partyMenus.take(6).toList();
      if (menus.isEmpty) {
        return const SizedBox(
            height: 80,
            child: Center(
              child: Text("No menus",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemCount: menus.length,
          itemBuilder: (context, index) {
            return _buildMenuCard(menus[index]);
          },
        ),
      );
    });
  }

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    // Party menu fields: id, title, description, price, image_url
    final String imageUrl = menu['image_url'] as String? ?? '';
    final String title = menu['title'] as String? ?? '';
    final double price = (menu['price'] as num?)?.toDouble() ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.MENU_DETAIL,
        arguments: {'id': menu['id']},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 10)
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 130,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                    Text(" (5.00)",
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Tk ${price.toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2))
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00B14F),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 1) {
            Get.toNamed(Routes.CART);
          }
        },
      ),
    );
  }
}
