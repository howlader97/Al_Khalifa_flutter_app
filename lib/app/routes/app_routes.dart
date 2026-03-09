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
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP = '/otp';
  static const RESET_PASSWORD = '/reset-password';
}
