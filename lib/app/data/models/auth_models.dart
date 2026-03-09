class SignUpRequest {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String district;
  String city;
  String address;
  String password;
  String confirmPassword;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.district,
    required this.city,
    required this.address,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'district': district,
    'city': city,
    'address': address,
    'password': password,
    'confirm_password': confirmPassword,
  };
}

class LoginRequest {
  String emailOrPhone;
  String password;

  LoginRequest({required this.emailOrPhone, required this.password});

  Map<String, dynamic> toJson() => {
    'email_or_phone': emailOrPhone,
    'password': password,
  };
}

class ForgotPasswordRequest {
  String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyOTPRequest {
  String email;
  String otpCode;

  VerifyOTPRequest({required this.email, required this.otpCode});

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp_code': otpCode,
  };
}

class ResetPasswordRequest {
  String resetToken;
  String newPassword;
  String confirmPassword;

  ResetPasswordRequest({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'reset_token': resetToken,
    'new_password': newPassword,
    'confirm_password': confirmPassword,
  };
}

class TokenResponse {
  String accessToken;
  String tokenType;

  TokenResponse({required this.accessToken, this.tokenType = 'bearer'});

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
    accessToken: json['access_token'],
    tokenType: json['token_type'] ?? 'bearer',
  );
}

class MessageResponse {
  String message;

  MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    message: json['message'] ?? '',
  );
}
