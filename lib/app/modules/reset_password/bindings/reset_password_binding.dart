import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';
import '../../../data/providers/auth_provider.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
