import 'package:get/get.dart';
import '../controllers/otp_controller.dart';
import '../../../data/providers/auth_provider.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<OtpController>(
      () => OtpController(authProvider: Get.find<AuthProvider>()),
    );
  }
}
