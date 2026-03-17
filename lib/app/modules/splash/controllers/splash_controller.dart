import 'package:get_storage/get_storage.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  final _storage = GetStorage();
  final _authProvider = AuthProvider();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final token = _storage.read('access_token');
    
    if (token == null) {
      Get.offAllNamed(Routes.ONBOARDING);
      return;
    }

    try {
      // Validate token by fetching user profile
      await _authProvider.getMe(token);
      // If successful, go to dashboard
      Get.offAllNamed(Routes.MAIN_DASHBOARD);
    } catch (e) {

      // If token is invalid/expired, go to login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
