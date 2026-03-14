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
  var currentSliderIndex = 0.obs;
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
  final PageController pageController = PageController();
  Timer? _sliderTimer;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
    _startSliderTimer();
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

  @override
  void onClose() {
    _sliderTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchAll() async {
    fetchCategories();
    fetchProducts();
    fetchPartyMenus();
    fetchSliders();
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

  void onCategoryTap(String? id) {
    selectedCategoryId.value = id;
    fetchProducts(categoryId: id);
  }
}
