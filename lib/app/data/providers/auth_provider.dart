import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthProvider {
  // Use 10.0.2.2 for Android Emulator to access host localhost
  static const String baseUrl = 'https://akfoodapi.maktechlaravel.cloud/auth';

  Future<TokenResponse> login(LoginRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to login');
    }
  }

  Future<TokenResponse> signup(SignUpRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to signup');
    }
  }

  Future<MessageResponse> forgotPassword(ForgotPasswordRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return MessageResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to request OTP');
    }
  }

  Future<TokenResponse> verifyOtp(VerifyOTPRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to verify OTP');
    }
  }

  Future<MessageResponse> resetPassword(ResetPasswordRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return MessageResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to reset password');
    }
  }

  Future<TokenResponse> googleLogin(GoogleLoginRequest data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Google login failed');
    }
  }
}
