import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/slider_provider.dart';

class HomeController extends GetxController {
  final ProductProvider _provider = ProductProvider();
  final SliderProvider _sliderProvider = SliderProvider();

  var isLoadingProducts = false.obs;
  var isLoadingCategories = false.obs;
  var isLoadingMenus = false.obs;
  var isLoadingSliders = false.obs;

  var products = <dynamic>[].obs;
  var categories = <dynamic>[].obs;
  var partyMenus = <dynamic>[].obs;
  var sliders = <dynamic>[].obs;
  var homeSections = <dynamic>[].obs;
  var currentSliderIndex = 0.obs;
  var currentCuisineIndex = 0.obs;
  var selectedCategoryId = RxnString();
  var searchQuery = "".obs;

  List<dynamic> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return products;
    }
    final query = searchQuery.value.toLowerCase();
    return products.where((product) {
      final name = (product['name'] as String? ?? '').toLowerCase();
      final description = (product['description'] as String? ?? '').toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();
  }

  List<dynamic> get filteredPartyMenus {
    if (searchQuery.value.isEmpty) {
      return partyMenus;
    }
    final query = searchQuery.value.toLowerCase();
    return partyMenus.where((menu) {
      final title = (menu['title'] as String? ?? '').toLowerCase();
      final description = (menu['description'] as String? ?? '').toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();
  }

  final int selectedBottomIndex = 0;
  final PageController pageController = PageController();
  final PageController cuisinePageController = PageController();
  Timer? _sliderTimer;
  Timer? _cuisineSliderTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
    _startSliderTimer();
    _startCuisineSliderTimer();
  }

  void _startSliderTimer() {
    _sliderTimer?.cancel();
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (sliders.isNotEmpty) {
        int nextIndex = (currentSliderIndex.value + 1) % sliders.length;
        if (pageController.hasClients) {
          pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _startCuisineSliderTimer() {
    _cuisineSliderTimer?.cancel();
    _cuisineSliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (partyMenus.isNotEmpty) {
        int nextIndex = (currentCuisineIndex.value + 1) % partyMenus.length;
        if (cuisinePageController.hasClients) {
          cuisinePageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void onClose() {
    _sliderTimer?.cancel();
    _cuisineSliderTimer?.cancel();
    pageController.dispose();
    cuisinePageController.dispose();
    super.onClose();
  }

  Future<void> fetchAll() async {
    fetchCategories();
    fetchProducts();
    fetchPartyMenus();
    fetchSliders();
    fetchHomeSections();
  }

  Future<void> fetchSliders() async {
    try {
      isLoadingSliders.value = true;
      final fetchedSliders = await _sliderProvider.getActiveSliders();
      print("Fetched Sliders: ${fetchedSliders.length}");
      sliders.value = fetchedSliders;
      currentSliderIndex.value = 0;
    } catch (e) {
      print("Error fetching sliders: $e");
    } finally {
      isLoadingSliders.value = false;
    }
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

  Future<void> fetchHomeSections() async {
    try {
      homeSections.value = await _provider.getHomeSections();
    } catch (e) {
      print("Error fetching home sections: $e");
    }
  }

  void onCategoryTap(String? id) {
    selectedCategoryId.value = id;
    fetchProducts(categoryId: id);
  }
}
