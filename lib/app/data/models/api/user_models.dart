// User API Models

class UserCreate {
  final String username;
  final String email;
  final String password;
  final String fullName;

  UserCreate({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
      };
}

class UserLogin {
  final String username;
  final String password;

  UserLogin({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class UserResponse {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        fullName: json['full_name'],
        isActive: json['is_active'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'full_name': fullName,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        tokenType: json['token_type'],
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': tokenType,
      };
}

class LoginResponse {
  final String message;
  final UserResponse user;
  final TokenResponse tokens;

  LoginResponse({
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'],
        user: UserResponse.fromJson(json['user']),
        tokens: TokenResponse.fromJson(json['tokens']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user.toJson(),
        'tokens': tokens.toJson(),
      };
}

class UserCreateResponse {
  final String message;
  final UserResponse user;
  final TokenResponse tokens;

  UserCreateResponse({
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory UserCreateResponse.fromJson(Map<String, dynamic> json) => UserCreateResponse(
        message: json['message'],
        user: UserResponse.fromJson(json['user']),
        tokens: TokenResponse.fromJson(json['tokens']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user.toJson(),
        'tokens': tokens.toJson(),
      };
}

class TokenRefresh {
  final String refreshToken;

  TokenRefresh({required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };
}
