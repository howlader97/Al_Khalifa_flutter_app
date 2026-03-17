import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';



class SignUpController extends GetxController {
  final AuthProvider authProvider;
  SignUpController({required this.authProvider});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final acceptTerms = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void signup() async {
    if (!acceptTerms.value) {
      Get.snackbar('Error', 'Please accept terms and conditions');
      return;
    }

    if (_hasEmptyFields()) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final request = SignUpRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        district: districtController.text,
        city: cityController.text,
        address: addressController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      await authProvider.signup(request);
      Get.snackbar('Success', 'Account created successfully. Please login.');
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Signup Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasEmptyFields() {
    return firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        districtController.text.isEmpty ||
        cityController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty;
  }

  void goToLogin() {
    Get.back();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final storage = GetStorage();
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

      await storage.write('access_token', response.accessToken);
      Get.offAllNamed(Routes.MAIN_DASHBOARD);
    } catch (e) {
      Get.snackbar('Google Login Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
