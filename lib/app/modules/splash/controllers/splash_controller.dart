import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    // For now, always go to onboarding. 
    // Later we can check if user is logged in.
    Get.offAllNamed(Routes.ONBOARDING);
  }
}
