import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final onboardingData = [
    {
      'image': 'assets/img/onboarding1.png',
      'title': 'Get Any Package Delivered',
      'description': 'Get your delicious food at your service in within less time',
    },
    {
      'image': 'assets/img/onboarding2.png',
      'title': 'Chose Your Meal',
      'description': 'All the best restaurants with their top menu waiting for you, they wait for your order',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      skip();
    }
  }

  void skip() {
    Get.offAllNamed('/login'); // We will define this route soon
  }
}
