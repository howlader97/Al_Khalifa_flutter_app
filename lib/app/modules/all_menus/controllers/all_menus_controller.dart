import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class AllMenusController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = false.obs;
  var menus = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    try {
      isLoading.value = true;
      final data = await _provider.getPartyMenus();
      menus.value = data['items'] ?? [];
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
