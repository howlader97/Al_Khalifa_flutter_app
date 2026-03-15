import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class DeleteAccountController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final GetStorage _storage = GetStorage();
  
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> deleteAccount() async {
    if (passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your password to confirm");
      return;
    }

    try {
      isLoading.value = true;
      final token = _storage.read('access_token');
      if (token == null) return;

      await _authProvider.deleteAccount(token, passwordController.text);
      
      // Logout on success
      _storage.erase();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Success", "Your account has been permanently deleted");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
