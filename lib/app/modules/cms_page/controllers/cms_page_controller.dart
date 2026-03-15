import 'package:get/get.dart';
import '../../../data/providers/cms_provider.dart';

class CmsPageController extends GetxController {
  final CmsProvider _cmsProvider = CmsProvider();
  
  var title = "".obs;
  var content = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['slug'] != null) {
      fetchPage(Get.arguments['slug']);
    }
  }

  Future<void> fetchPage(String slug) async {
    try {
      isLoading.value = true;
      final page = await _cmsProvider.getPage(slug);
      title.value = page['title'] ?? '';
      content.value = page['content'] ?? '';
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
