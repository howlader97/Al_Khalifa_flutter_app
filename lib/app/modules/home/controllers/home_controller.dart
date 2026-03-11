import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';

class HomeController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoadingProducts = false.obs;
  var isLoadingCategories = false.obs;
  var isLoadingMenus = false.obs;

  var products = <dynamic>[].obs;
  var categories = <dynamic>[].obs;
  var partyMenus = <dynamic>[].obs;
  var selectedCategoryId = RxnString();
  var searchQuery = "".obs;

  List<dynamic> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    }
    return products.where((product) {
      final name = (product['name'] as String? ?? '').toLowerCase();
      return name.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  final int selectedBottomIndex = 0;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    fetchCategories();
    fetchProducts();
    fetchPartyMenus();
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      categories.value = await _provider.getCategories();
    } catch (_) {} finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchProducts({String? categoryId}) async {
    try {
      isLoadingProducts.value = true;
      final data = await _provider.getProducts(categoryId: categoryId);
      products.value = data['items'] ?? [];
    } catch (_) {} finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchPartyMenus() async {
    try {
      isLoadingMenus.value = true;
      final data = await _provider.getPartyMenus();
      partyMenus.value = data['items'] ?? [];
    } catch (_) {} finally {
      isLoadingMenus.value = false;
    }
  }

  void onCategoryTap(String? id) {
    selectedCategoryId.value = id;
    fetchProducts(categoryId: id);
  }
}
