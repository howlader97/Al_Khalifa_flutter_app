import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthProvider authProvider;
  LoginController({required this.authProvider});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final storage = GetStorage();

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final request = LoginRequest(
        emailOrPhone: emailController.text,
        password: passwordController.text,
      );
      final response = await authProvider.login(request);
      
      // Save token
      await storage.write('token', response.accessToken);
      
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToSignUp() {
    Get.toNamed('/signup'); // Will implement shortly
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password'); // Will implement shortly
  }
}
