import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../controllers/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: _buildField('First Name', controller.firstNameController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildField('Last Name', controller.lastNameController)),
                ],
              ),
              const SizedBox(height: 15),
              _buildField('Email', controller.emailController),
              const SizedBox(height: 15),
              _buildField('Number', controller.phoneController),
              const SizedBox(height: 15),
              Row(
                children: [
                   Expanded(child: _buildField('District', controller.districtController)),
                   const SizedBox(width: 15),
                   Expanded(child: _buildField('City', controller.cityController)),
                ],
              ),
              const SizedBox(height: 15),
              _buildField('Address', controller.addressController, hint: 'Example: House no 20'),
              const SizedBox(height: 15),
              Obx(() => _buildField(
                    'Create Password',
                    controller.passwordController,
                    isPassword: true,
                    isVisible: controller.isPasswordVisible.value,
                    onToggle: () => controller.isPasswordVisible.toggle(),
                  )),
              const SizedBox(height: 15),
              Obx(() => _buildField(
                    'Confirm Password',
                    controller.confirmPasswordController,
                    isPassword: true,
                    isVisible: controller.isConfirmPasswordVisible.value,
                    onToggle: () => controller.isConfirmPasswordVisible.toggle(),
                  )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.acceptTerms.value,
                        onChanged: (val) => controller.acceptTerms.value = val!,
                        activeColor: AppColors.primary,
                      )),
                  const Text('I Accept All Terms & Conditions'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16)),
                    )),
              ),
              const SizedBox(height: 20),
              const Center(child: Text('Or Sign Up With')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _socialIcon(Icons.star_outline), 
                   const SizedBox(width: 20),
                   _socialIcon(Icons.star_outline),
                   const SizedBox(width: 20),
                   _socialIcon(Icons.star_outline),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: controller.goToLogin,
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                      children: const [
                        TextSpan(
                          text: 'Log In',
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool isPassword = false,
    String? hint,
    bool? isVisible,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: isPassword ? !(isVisible ?? false) : false,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter your ${label.toLowerCase()}',
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (isVisible ?? false) ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon), 
    );
  }
}
