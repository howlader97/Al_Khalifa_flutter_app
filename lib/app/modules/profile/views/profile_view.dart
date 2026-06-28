import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note, color: Colors.black, size: 28.r),
            onPressed: () => controller.goToEditProfile(),
          ),
        ],
        surfaceTintColor: Colors.white,
        automaticallyImplyActions: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F)));
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text("User not found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadUserProfile(),
          color: const Color(0xFF00B14F),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                _buildProfileHeader(user),
                SizedBox(height: 10.h),
                _buildProfileMenu(),
                SizedBox(height: 20.h),
                _buildLogoutButton(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!, width: 4.r),
                image: DecorationImage(
                  image: user.profileImgUrl != null && user.profileImgUrl!.isNotEmpty
                      ? NetworkImage(user.profileImgUrl!)
                      : const AssetImage('assets/img/user_placeholder.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Icon(Icons.camera_alt_outlined, size: 20.r, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "${user.firstName} ${user.lastName}",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        if (user.phoneNumber != null)
          Text(
            user.phoneNumber!,
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
        SizedBox(height: 4.h),
        Text(
          user.email,
          style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildProfileMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildMenuItem(Icons.notifications_active_outlined, "Notifications", () => Get.toNamed(Routes.NOTIFICATION)),
          _buildMenuItem(Icons.person_add_alt_1_outlined, "Invite Friend", () {}),
          _buildMenuItem(Icons.history, "Order History", () {
            Get.toNamed(Routes.MY_ORDERS);
          }),
          _buildMenuItem(Icons.delete_outline, "Delete Account", () => controller.goToDeleteAccount(), isDestructive: true),
          _buildMenuItem(Icons.info_outline, "About Us", () {
            Get.toNamed(Routes.CMS_PAGE, arguments: {'slug': 'about-us'});
          }),
          _buildMenuItem(Icons.privacy_tip_outlined, "Privacy & Policy", () {
            Get.toNamed(Routes.CMS_PAGE, arguments: {'slug': 'privacy-policy'});
          }),
          _buildMenuItem(Icons.description_outlined, "Terms & Conditions", () {
            Get.toNamed(Routes.CMS_PAGE, arguments: {'slug': 'terms-conditions'});
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: isDestructive ? Colors.red[50] : Colors.grey[100], borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, color: isDestructive ? Colors.red : Colors.black87, size: 22.r),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: isDestructive ? Colors.red[700] : Colors.black87),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(color: Colors.grey[100], height: 1),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: OutlinedButton(
        onPressed: () => controller.logout(),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h),
          side: const BorderSide(color: Colors.black87),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text(
          "Log Out",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ),
    );
  }
}
