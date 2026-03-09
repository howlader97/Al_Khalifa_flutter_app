import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../utils/app_colors.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We sent verification code to your email address\n${controller.email.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Pinput(
                length: 6,
                controller: controller.otpController,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.transparent),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.verify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Next', style: TextStyle(color: Colors.white, fontSize: 16)),
                    )),
              ),
              const SizedBox(height: 30),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive a code? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: controller.timerSeconds.value == 0 ? controller.resendOtp : null,
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            color: controller.timerSeconds.value == 0
                                ? AppColors.primary
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => controller.timerSeconds.value > 0
                  ? Text(
                      '00:${controller.timerSeconds.value.toString().padLeft(2, '0')} sec',
                      style: const TextStyle(color: Colors.grey),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
