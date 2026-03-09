import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../data/providers/auth_provider.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
