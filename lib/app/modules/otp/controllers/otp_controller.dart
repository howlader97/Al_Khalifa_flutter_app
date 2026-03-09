import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  final AuthProvider authProvider;
  OtpController({required this.authProvider});

  final otpController = TextEditingController();
  final isLoading = false.obs;
  final email = ''.obs;

  final timerSeconds = 59.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments['email'] ?? '';
    startTimer();
  }

  void startTimer() {
    timerSeconds.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void verify() async {
    if (otpController.text.length < 6) {
      Get.snackbar('Error', 'Please enter a 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final request = VerifyOTPRequest(
        email: email.value,
        otpCode: otpController.text,
      );
      final response = await authProvider.verifyOtp(request);
      Get.toNamed(Routes.RESET_PASSWORD, arguments: {'reset_token': response.accessToken});
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    isLoading.value = true;
    try {
      final request = ForgotPasswordRequest(email: email.value);
      await authProvider.forgotPassword(request);
      Get.snackbar('OTP Sent', 'An OTP has been resent to your email');
      startTimer();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
