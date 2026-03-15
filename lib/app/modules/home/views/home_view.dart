import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    );
  }

  Widget _buildHeader() {
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
          IconButton(
              icon: Icon(Icons.notifications_none_outlined, size: 24.r),
              onPressed: () {}),
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
            color: Colors.black.withOpacity(0.1),
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
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.3),
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
              color: const Color(0xFF00B14F).withOpacity(0.3),
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
                        color: Colors.white.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w500)),
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
        height: 105.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: menus.length,
          separatorBuilder: (_, __) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            final menu = menus[index]; // fields: id, title, image_url
            final imageUrl = menu['image_url'] as String? ?? '';
            final title = menu['title'] as String? ?? '';
            return SizedBox(
              width: 70.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8.r)
                        ],
                      ),
                      child: imageUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.restaurant_menu,
                                        color: const Color(0xFF00B14F), size: 24.r),
                              ),
                            )
                          : Icon(Icons.restaurant_menu,
                              color: const Color(0xFF00B14F), size: 24.r),
                    ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.sp, color: Colors.black87),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.72, // Modified to prevent overflow
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
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 10.r)
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.7, // Taller for mobile consistency
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
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 10.r)
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
                    height: 110.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 110.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey, size: 24.r),
                    ),
                  )
                : Container(
                    height: 110.h,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey, size: 24.r)),
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _buildRatingStars((menu['rating'] as num?)?.toDouble() ?? 5.0, size: 12.r),
                    SizedBox(width: 4.w),
                    Text("(${(menu['review_count'] ?? 0)})",
                        style:
                            TextStyle(fontSize: 11.sp, color: Colors.grey)),
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
      )
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
