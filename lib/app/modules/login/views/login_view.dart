import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Log In',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Your Account',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              const Text('Email Or Number', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email or number',
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.goToForgotPassword,
                  child: const Text(
                    'Forgotten Password',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 16)),
                    )),
              ),
              const SizedBox(height: 30),
              const Center(child: Text('Or Log In With')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _socialIcon('assets/img/google.png'), // Need to ensure these exist or use placeholders
                   const SizedBox(width: 20),
                   _socialIcon('assets/img/apple.png'),
                   const SizedBox(width: 20),
                   _socialIcon('assets/img/facebook.png'),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: controller.goToSignUp,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                      children: const [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.star_outline), // Placeholder since I don't have the icons yet
    );
  }
}
