import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/auth_provider.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final GetStorage _storage = GetStorage();
  
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController(); // Email is often read-only, but let's show it
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    final profileController = Get.find<ProfileController>();
    final user = profileController.user.value;
    if (user != null) {
      nameController.text = "${user.firstName} ${user.lastName}";
      phoneController.text = user.phoneNumber ?? "";
      emailController.text = user.email;
      districtController.text = user.district ?? "";
      cityController.text = user.city ?? "";
      addressController.text = user.address ?? "";
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = _storage.read('access_token');
      if (token == null) return;

      // Simple name splitting for this demo
      List<String> names = nameController.text.split(" ");
      String firstName = names.isNotEmpty ? names[0] : "";
      String lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      final Map<String, dynamic> updateData = {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneController.text,
        'district': districtController.text,
        'city': cityController.text,
        'address': addressController.text,
      };

      await _authProvider.updateProfile(token, updateData);
      
      // Reload profile data
      Get.find<ProfileController>().loadUserProfile();
      
      Get.back();
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    districtController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
