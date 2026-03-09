import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../data/providers/auth_provider.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<SignUpController>(
      () => SignUpController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
