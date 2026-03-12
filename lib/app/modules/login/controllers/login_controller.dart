import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthProvider authProvider;
  LoginController({required this.authProvider});

  final emailController = TextEditingController(text: "customer1@example.com");
  final passwordController = TextEditingController(text: "password123");
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final storage = GetStorage();
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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

      print("login response: $response");
      
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

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final names = googleUser.displayName?.split(' ') ?? ['Google', 'User'];
      final firstName = names[0];
      final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

      final request = GoogleLoginRequest(
        email: googleUser.email,
        firstName: firstName,
        lastName: lastName,
        idToken: googleAuth.idToken ?? '',
      );

      final response = await authProvider.googleLogin(request);
      
      await storage.write('token', response.accessToken);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Google Login Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.toNamed('/signup'); // Will implement shortly
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password'); // Will implement shortly
  }
}
