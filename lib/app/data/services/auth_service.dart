import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';
import '../models/api/user_models.dart';

class AuthService extends GetxService {
  final ApiClient _apiClient = ApiClient.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _apiClient.loadTokensFromStorage();
  }

  /// Sign up a new user
  Future<UserCreateResponse> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    final userData = UserCreate(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );

    final response = await _apiClient.post(
      ApiConfig.signup,
      data: userData.toJson(),
    );

    final userCreateResponse = UserCreateResponse.fromJson(response.data);

    // Save tokens
    await _apiClient.setTokens(
      userCreateResponse.tokens.accessToken,
      userCreateResponse.tokens.refreshToken,
    );

    return userCreateResponse;
  }

  /// Login user
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final loginData = UserLogin(
      username: username,
      password: password,
    );

    final response = await _apiClient.post(
      ApiConfig.login,
      data: loginData.toJson(),
    );

    final loginResponse = LoginResponse.fromJson(response.data);

    // Save tokens
    await _apiClient.setTokens(
      loginResponse.tokens.accessToken,
      loginResponse.tokens.refreshToken,
    );

    return loginResponse;
  }

  /// Refresh access token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    final tokenRefresh = TokenRefresh(refreshToken: refreshToken);

    final response = await _apiClient.post(
      ApiConfig.refresh,
      data: tokenRefresh.toJson(),
    );

    final tokenResponse = TokenResponse.fromJson(response.data);

    // Save new tokens
    await _apiClient.setTokens(
      tokenResponse.accessToken,
      tokenResponse.refreshToken,
    );

    return tokenResponse;
  }

  /// Get current user info
  Future<UserResponse> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.me);
    return UserResponse.fromJson(response.data);
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConfig.logout);
    } catch (e) {
      // Even if logout fails on server, clear local tokens
    } finally {
      await _apiClient.clearTokens();
    }
  }

  /// Check if username is available
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      await _apiClient.get(ApiConfig.checkUsername(username));
      return true; // Username is available
    } catch (e) {
      return false; // Username is not available
    }
  }

  /// Check if email is available
  Future<bool> checkEmailAvailability(String email) async {
    try {
      await _apiClient.get(ApiConfig.checkEmail(email));
      return true; // Email is available
    } catch (e) {
      return false; // Email is not available
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _apiClient.isAuthenticated;

  /// Clear authentication state
  Future<void> clearAuth() async {
    await _apiClient.clearTokens();
  }
}
