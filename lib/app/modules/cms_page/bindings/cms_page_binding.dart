import 'package:get/get.dart';

import '../controllers/cms_page_controller.dart';

class CmsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CmsPageController>(
      () => CmsPageController(),
    );
  }
}
