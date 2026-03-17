import 'dart:convert';
import 'dart:io';
import 'package:akflutterfoodapp/app/data/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/auth_models.dart';
import 'package:path/path.dart' as path;


class AuthProvider {
   static final String baseUrl = '$apiBaseUrl/auth';
  // For local development on Android Emulator use:
  // static const String baseUrl = 'http://10.0.2.2:8004/auth';
  // For Real Device or Web use your local IP, e.g., 'http://192.168.0.100:8004/auth'

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

  Future<UserRead> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      return UserRead.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to get user profile');
    }
  }

  Future<UserRead> updateProfile(String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );




    if (response.statusCode == 200) {
      return UserRead.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to update profile');
    }
  }

  Future<MessageResponse> deleteAccount(String token, String password) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode == 200) {
      return MessageResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to delete account');
    }
  }

   Future<UserRead> uploadProfileImage(String token, String filePath) async {
     final uri = Uri.parse('$baseUrl/update-avatar');
     final request = http.MultipartRequest('POST', uri);

     // Headers
     request.headers.addAll({
       'Authorization': 'Bearer $token',
       'Accept': 'application/json',
     });


     final String extension = path.extension(filePath).toLowerCase().replaceAll('.', '');
     String type = 'image';
     String subtype = extension.isEmpty ? 'jpeg' : extension;


     final file = await http.MultipartFile.fromPath(
       'file',
       filePath,
       contentType: MediaType(type, subtype),
     );

     request.files.add(file);

     try {

       final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
       final response = await http.Response.fromStream(streamedResponse);

       if (response.statusCode == 200 || response.statusCode == 201) {
         final decodedJson = jsonDecode(response.body);
         return UserRead.fromJson(decodedJson);
       } else {
         final errorData = jsonDecode(response.body);
         throw errorData['detail'] ?? "Upload failed with status: ${response.statusCode}";
       }
     } on SocketException {
       throw "No Internet connection";
     } catch (e) {
       throw e.toString();
     }
   }
}
