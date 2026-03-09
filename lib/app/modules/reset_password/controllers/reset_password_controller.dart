import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final AuthProvider authProvider;
  ResetPasswordController({required this.authProvider});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  
  String? resetToken;

  @override
  void onInit() {
    super.onInit();
    resetToken = Get.arguments['reset_token'];
  }

  void resetPassword() async {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (resetToken == null) {
      Get.snackbar('Error', 'Invalid reset session');
      return;
    }

    isLoading.value = true;
    try {
      final request = ResetPasswordRequest(
        resetToken: resetToken!,
        newPassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      await authProvider.resetPassword(request);
      Get.snackbar('Success', 'Password reset successfully. Please login.');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
