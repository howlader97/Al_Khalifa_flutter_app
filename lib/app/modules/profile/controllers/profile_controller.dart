import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/models/auth_models.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final GetStorage _storage = GetStorage();
  final ImagePicker _picker = ImagePicker();
  
  var user = Rxn<UserRead>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final token = _storage.read('access_token');
      if (token != null) {
        print("token: $token");
        user.value = await _authProvider.getMe(token);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        isLoading.value = true;

        final token = _storage.read('access_token');
        if (token != null) {

          final updatedUser = await _authProvider.uploadProfileImage(token, image.path);

          user.value = updatedUser;

          Get.snackbar(
            "Success",
            "Profile image updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar("Error", "Session expired. Please login again.");
        }
      }
    } catch (e) {
      print("Upload Error: $e");
      Get.snackbar(
        "Error",
        e.toString().contains("Exception:") ? e.toString().split("Exception: ").last : e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _storage.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  void goToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void goToDeleteAccount() {
    Get.toNamed(Routes.DELETE_ACCOUNT);
  }
}
