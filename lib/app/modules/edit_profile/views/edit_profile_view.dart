import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildInputField("Name", controller.nameController, "Your Name"),
              SizedBox(height: 20.h),
              _buildInputField("Phone number", controller.phoneController, "01xxxx-xxx", keyboardType: TextInputType.phone),
              SizedBox(height: 20.h),
              _buildInputField("Email", controller.emailController, "company@gmail.com", isReadOnly: true, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: _buildInputField("District", controller.districtController, "Enter Your District")),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildInputField("City", controller.cityController, "Enter Your City")),
                ],
              ),
              SizedBox(height: 20.h),
              _buildInputField("Address", controller.addressController, "Example: House no 32, street, etc", maxLines: 3),
              SizedBox(height: 40.h),
              _buildSaveButton(),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController textController,
    String hint, {
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: textController,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[50] : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFF00B14F), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006437), // Dark green as per screenshot
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Save",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
      ),
    );
  }
}
