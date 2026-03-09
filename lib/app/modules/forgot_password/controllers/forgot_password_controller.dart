import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final AuthProvider authProvider;
  ForgotPasswordController({required this.authProvider});

  final emailController = TextEditingController();
  final isLoading = false.obs;

  void sendOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    try {
      final request = ForgotPasswordRequest(email: emailController.text);
      await authProvider.forgotPassword(request);
      Get.snackbar('OTP Sent', 'An OTP has been sent to your email');
      Get.toNamed(Routes.OTP, arguments: {'email': emailController.text});
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
