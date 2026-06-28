import 'package:get/get.dart';

import '../modules/main_dashboard/bindings/main_dashboard_binding.dart';
import '../modules/main_dashboard/views/main_dashboard_view.dart';

import '../modules/all_menus/bindings/all_menus_binding.dart';
import '../modules/all_menus/views/all_menus_view.dart';
import '../modules/all_products/bindings/all_products_binding.dart';
import '../modules/all_products/views/all_products_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/cms_page/bindings/cms_page_binding.dart';
import '../modules/cms_page/views/cms_page_view.dart';
import '../modules/delete_account/bindings/delete_account_binding.dart';
import '../modules/delete_account/views/delete_account_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/menu_detail/bindings/menu_detail_binding.dart';
import '../modules/menu_detail/views/menu_detail_view.dart';
import '../modules/my_orders/bindings/my_orders_binding.dart';
import '../modules/my_orders/views/my_orders_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.MAIN_DASHBOARD, page: () => const MainDashboardView(), binding: MainDashboardBinding()),
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: _Paths.ONBOARDING, page: () => const OnboardingView(), binding: OnboardingBinding()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.SIGNUP, page: () => const SignUpView(), binding: SignUpBinding()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => const ForgotPasswordView(), binding: ForgotPasswordBinding()),
    GetPage(name: _Paths.OTP, page: () => const OtpView(), binding: OtpBinding()),
    GetPage(name: _Paths.RESET_PASSWORD, page: () => const ResetPasswordView(), binding: ResetPasswordBinding()),
    GetPage(name: _Paths.PRODUCT_DETAIL, page: () => const ProductDetailView(), binding: ProductDetailBinding()),
    GetPage(name: _Paths.ALL_PRODUCTS, page: () => const AllProductsView(), binding: AllProductsBinding()),
    GetPage(name: _Paths.ALL_MENUS, page: () => const AllMenusView(), binding: AllMenusBinding()),
    GetPage(name: _Paths.MENU_DETAIL, page: () => const MenuDetailView(), binding: MenuDetailBinding()),
    GetPage(name: _Paths.CART, page: () => const CartView(), binding: CartBinding()),
    GetPage(name: _Paths.CHECKOUT, page: () => const CheckoutView(), binding: CheckoutBinding()),
    GetPage(name: _Paths.MY_ORDERS, page: () => const MyOrdersView(), binding: MyOrdersBinding()),
    GetPage(name: _Paths.ORDER_DETAILS, page: () => const OrderDetailsView(), binding: OrderDetailsBinding()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView(), binding: ProfileBinding()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => const EditProfileView(), binding: EditProfileBinding()),
    GetPage(name: _Paths.DELETE_ACCOUNT, page: () => const DeleteAccountView(), binding: DeleteAccountBinding()),
    GetPage(name: _Paths.CMS_PAGE, page: () => const CmsPageView(), binding: CmsPageBinding()),
    GetPage(name: _Paths.NOTIFICATION, page: () => const NotificationView(), binding: NotificationBinding()),
  ];
}
