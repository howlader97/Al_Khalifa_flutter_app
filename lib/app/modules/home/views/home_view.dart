import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routes/app_pages.dart';
import '../../notification/controllers/notification_controller.dart';
import '../controllers/home_controller.dart';

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
              child: Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchAll(),
                    color: const Color(0xFF00B14F),
                    child: _buildSearchResults(context),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => controller.fetchAll(),
                  color: const Color(0xFF00B14F),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        const SizedBox(height: 16),
                        // Dynamic Product Sections
                        Column(
                          children: controller.homeSections.map((section) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                _buildSectionHeader(
                                  section['name'],
                                  onSeeAll: () => Get.toNamed(
                                    Routes.ALL_PRODUCTS,
                                    arguments: {"section_id": section['id'], "title": section['name']},
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildProductGrid(context, 
                                    products: section['products'], 
                                    limit: 4),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionHeader("All Products", onSeeAll: () => Get.toNamed(Routes.ALL_PRODUCTS, arguments: {"title": "All Products"})),
                        const SizedBox(height: 12),
                        _buildProductGrid(context, 
                            products: controller.filteredProducts, 
                            limit: 6),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final notificationController = Get.find<NotificationController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: const Color(0xFF00B14F), size: 22.r),
              SizedBox(width: 4.w),
              Text("AL-Khalifa Restaurant\n& Convention Hall",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10.sp))
            ],
          ),
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.notifications_none_outlined, size: 24.r),
                  onPressed: () {
                    Get.toNamed(Routes.NOTIFICATION);
                  }),
              Positioned(
                right: 8.w,
                top: 8.h,
                child: Obx(() => notificationController.unreadCount.value > 0
                    ? Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14.r,
                          minHeight: 14.r,
                        ),
                        child: Text(
                          '${notificationController.unreadCount.value > 9 ? '9+' : notificationController.unreadCount.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: "Search for food",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.r),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Obx(() {
      if (controller.isLoadingSliders.value) {
        return _buildShimmerLoading();
      }

      if (controller.sliders.isEmpty) {
        return _buildStaticBanner();
      }

      return Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: (index) => controller.currentSliderIndex.value = index,
              itemCount: controller.sliders.length,
              itemBuilder: (context, index) {
                final slider = controller.sliders[index];
                return _buildSliderItem(slider);
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildSliderIndicators(),
        ],
      );
    });
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F))),
      ),
    );
  }

  Widget _buildSliderItem(dynamic slider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              slider['image_url'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF00B14F),
                child: const Icon(Icons.image_not_supported, color: Colors.white, size: 50),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha:0.8),
                    Colors.black.withValues(alpha:0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (slider['title'] != null && (slider['title'] as String).isNotEmpty)
                    Text(
                      slider['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                    ),
                  if (slider['link_url'] != null && (slider['link_url'] as String).isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B14F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.sliders.length,
        (index) => Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.h,
          width: controller.currentSliderIndex.value == index ? 20.w : 6.w,
          decoration: BoxDecoration(
            color: controller.currentSliderIndex.value == index
                ? const Color(0xFF00B14F)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(3.r),
          ),
        )),
      ),
    );
  }

  Widget _buildStaticBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF00B14F),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B14F).withValues(alpha:0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Share the love",
                    style: TextStyle(
                        color: Colors.white.withValues(alpha:0.85), fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text(
                  "Enjoy\nDiscount Food",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      height: 1.1),
                ),
              ],
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.lunch_dining, size: 100, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {String? subtitle, VoidCallback? onSeeAll}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.sp)),
              if (subtitle != null)
                Text(subtitle,
                    style:
                        TextStyle(color: Colors.grey, fontSize: 12.sp)),
            ],
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text("See All",
                style: TextStyle(
                    color: const Color(0xFF00B14F),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp)),
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
            height: 120,
            child: Center(
                child: CircularProgressIndicator(color: Color(0xFF00B14F))));
      }
      final menus = controller.partyMenus;
      if (menus.isEmpty) {
        return const SizedBox(
            height: 120,
            child: Center(
                child: Text("No cuisines",
                    style: TextStyle(color: Colors.grey, fontSize: 13))));
      }
      return Column(
        children: [
          SizedBox(
            height: 130.h,
            child: PageView.builder(
              controller: controller.cuisinePageController,
              onPageChanged: (index) =>
                  controller.currentCuisineIndex.value = index,
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                final imageUrl = menu['image_url'] as String? ?? '';
                final title = menu['title'] as String? ?? '';
                final double rating=menu["rating"];
                return GestureDetector(
                  onTap: () => Get.toNamed(
                    Routes.MENU_DETAIL,
                    arguments: {'id': menu['id']},
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10.r,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(16.r)),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: 120.w,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 120.w,
                                    color: Colors.grey[100],
                                    child: Icon(Icons.restaurant_menu,
                                        color: const Color(0xFF00B14F),
                                        size: 32.r),
                                  ),
                                )
                              : Container(
                                  width: 120.w,
                                  color: Colors.grey[100],
                                  child: Icon(Icons.restaurant_menu,
                                      color: const Color(0xFF00B14F),
                                      size: 32.r),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        for(int i=0;i<rating;i++)
                                          Icon(Icons.star, color: Colors.amber, size: 16.r),
                                      ],
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      rating.toString(), // Hardcoded for design, can be dynamic
                                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          _buildCuisineIndicators(),
        ],
      );
    });
  }

  Widget _buildCuisineIndicators() {
    return Obx(() {
      final count = controller.partyMenus.length;
      if (count <= 1) return const SizedBox.shrink();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            height: 6.h,
            width: controller.currentCuisineIndex.value == index ? 18.w : 6.w,
            decoration: BoxDecoration(
              color: controller.currentCuisineIndex.value == index
                  ? const Color(0xFF00B14F)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ),
      );
    });
  }

  // ---- Dynamic Sections: uses products passed from controller.homeSections ----
  Widget _buildProductGrid(BuildContext context,
      {required List<dynamic> products, int limit = 4}) {
    if (products.isEmpty) {
      return const SizedBox(
          height: 80,
          child: Center(
              child: Text("No products",
                  style: TextStyle(color: Colors.grey, fontSize: 13))));
    }
    final items = products.take(limit).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, items[index]);
        },
      ),
    );
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
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha:0.06), blurRadius: 10.r)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(14.r)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 120.h, // Slightly reduced height to give more room for text
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 120.h,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: Colors.grey, size: 24.r),
                          ),
                        )
                      : Container(
                          height: 120.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey, size: 24.r)),
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                        color: Color(0xFF00B14F),
                        shape: BoxShape.circle),
                    child: Icon(Icons.add,
                        color: Colors.white, size: 18.r),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      _buildRatingStars((product['rating'] as num?)?.toDouble() ?? 5.0, size: 12.r),
                      SizedBox(width: 4.w),
                      Text("(${(product['review_count'] ?? 0)})",
                          style: TextStyle(
                              fontSize: 11.sp, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Tk ${price.toStringAsFixed(0)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
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

  Widget _buildSearchResults(BuildContext context) {
    final searchMenus = controller.filteredPartyMenus;
    final searchProducts = controller.filteredProducts;

    if (searchMenus.isEmpty && searchProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60.r, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              "No results found for \"${controller.searchQuery.value}\"",
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchMenus.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text("Matched Cuisines",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchMenus.length,
              itemBuilder: (context, index) {
                final menu = searchMenus[index];
                return _buildSearchMenuTile(menu);
              },
            ),
          ],
          if (searchProducts.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text("Matched Products",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
            const SizedBox(height: 12),
            _buildProductGrid(context, products: searchProducts, limit: 100),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchMenuTile(dynamic menu) {
    final String imageUrl = menu['image_url'] as String? ?? '';
    final String title = menu['title'] as String? ?? '';
    final double price = (menu['price'] as num?)?.toDouble() ?? 0;
    final double rating = (menu['rating'] as num?)?.toDouble() ?? 5.0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.MENU_DETAIL,
        arguments: {'id': menu['id']},
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha:0.04),
                blurRadius: 10.r,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70.w,
                        height: 70.w,
                        color: Colors.grey[100],
                        child: Icon(Icons.restaurant_menu,
                            color: const Color(0xFF00B14F), size: 24.r),
                      ),
                    )
                  : Container(
                      width: 70.w,
                      height: 70.w,
                      color: Colors.grey[100],
                      child: Icon(Icons.restaurant_menu,
                          color: const Color(0xFF00B14F), size: 24.r),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.r),
                      SizedBox(width: 4.w),
                      Text(rating.toString(),
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text("Tk ${price.toStringAsFixed(0)}",
                      style: TextStyle(
                          color: const Color(0xFF00B14F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
