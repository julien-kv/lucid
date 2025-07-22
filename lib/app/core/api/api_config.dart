class ApiConfig {
  // Base URL - Easily modifiable
  static const String baseUrl = 'https://your-api-domain.com';

  // Alternative base URLs for different environments
  static const String devBaseUrl = 'https://30c8f31a65b4.ngrok-free.app/';
  static const String stagingBaseUrl = 'https://staging-api.your-domain.com';
  static const String prodBaseUrl = 'https://api.your-domain.com';

  // Current environment base URL
  static String get currentBaseUrl {
    // You can change this to switch environments easily
    return devBaseUrl; // Change to prodBaseUrl for production
  }

  // API Version
  static const String apiVersion = '/api/v1';

  // Full API base URL
  static String get apiBaseUrl => '$currentBaseUrl$apiVersion';

  // Authentication endpoints
  static const String signup = '/auth/signup';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static String checkUsername(String username) => '/check-username/$username';
  static String checkEmail(String email) => '/check-email/$email';

  // Journal endpoints
  static const String journals = '/journals';
  static String journalById(int id) => '/journals/$id';
  static String journalsByMood(String mood) => '/journals/mood/$mood';
  static const String moodStats = '/journals/stats/mood-count';
  static const String moods = '/moods';

  // Prompts endpoints
  static const String prompts = '/prompts';
  static String promptById(int id) => '/prompts/$id';
  static const String promptCategories = '/prompts/categories';
  static const String randomPrompt = '/prompts/random';
  static String promptsByCategory(String category) => '/prompts/category/$category';

  // Challenges endpoints
  static const String challenges = '/challenges';
  static String challengeById(int id) => '/challenges/$id';
  static String searchChallengesByName(String name) => '/challenges/search/$name';
  static const String challengeStats = '/challenges/stats/summary';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, String> authHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };
}
