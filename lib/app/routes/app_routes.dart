// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const OTP = _Paths.OTP;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const ALL_PRODUCTS = _Paths.ALL_PRODUCTS;
  static const ALL_MENUS = _Paths.ALL_MENUS;
  static const MENU_DETAIL = _Paths.MENU_DETAIL;
  static const CART = _Paths.CART;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const MY_ORDERS = _Paths.MY_ORDERS;
  static const ORDER_DETAILS = _Paths.ORDER_DETAILS;
  static const PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const DELETE_ACCOUNT = _Paths.DELETE_ACCOUNT;
  static const MAIN_DASHBOARD = _Paths.MAIN_DASHBOARD;
  static const CMS_PAGE = _Paths.CMS_PAGE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
}

abstract class _Paths {
  _Paths._();
  static const MAIN_DASHBOARD = '/main-dashboard';
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP = '/otp';
  static const RESET_PASSWORD = '/reset-password';
  static const PRODUCT_DETAIL = '/product-detail';
  static const ALL_PRODUCTS = '/all-products';
  static const ALL_MENUS = '/all-menus';
  static const MENU_DETAIL = '/menu-detail';
  static const CART = '/cart';
  static const CHECKOUT = '/checkout';
  static const MY_ORDERS = '/my-orders';
  static const ORDER_DETAILS = '/order-details';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const DELETE_ACCOUNT = '/delete-account';
  static const CMS_PAGE = '/cms-page';
  static const NOTIFICATION = '/notification';
}
