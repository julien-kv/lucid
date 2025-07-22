# API Configuration

This directory contains the API configuration and client setup for the Lucid journaling app.

## 🔧 Modifying the Base URL

To change the API base URL, simply edit the `ApiConfig` class in `api_config.dart`:

### Quick Change
```dart
// In api_config.dart, modify the currentBaseUrl getter:
static String get currentBaseUrl {
  return devBaseUrl;     // For development
  // return stagingBaseUrl;  // For staging
  // return prodBaseUrl;     // For production
}
```

### Environment URLs
The following predefined URLs are available:

- **Development**: `http://localhost:8000`
- **Staging**: `https://staging-api.your-domain.com`
- **Production**: `https://api.your-domain.com`

You can modify these URLs in the constants section:

```dart
static const String devBaseUrl = 'http://localhost:8000';
static const String stagingBaseUrl = 'https://staging-api.your-domain.com';
static const String prodBaseUrl = 'https://api.your-domain.com';
```

## 📁 File Structure

```
api/
├── api_config.dart      # Configuration and endpoints
├── api_client.dart      # HTTP client with auth handling
└── README.md           # This file
```

## 🔐 Authentication

The API client automatically handles:
- JWT token storage
- Token refresh when expired
- Auto-retry failed requests after token refresh
- Automatic logout on authentication failure

## 🛠️ Services

The app includes these API services:

### AuthService
- User signup/login
- Token management
- Username/email availability checking

### JournalService  
- CRUD operations for journal entries
- Mood filtering
- Statistics retrieval

## 🚀 Usage

Services are automatically initialized in `main.dart` and can be accessed anywhere using GetX:

```dart
// Get auth service
final authService = Get.find<AuthService>();

// Get journal service  
final journalService = Get.find<JournalService>();
```

## 🔍 Error Handling

The API client provides comprehensive error handling:

- `NetworkException`: Connection issues
- `ValidationException`: Form validation errors  
- `UnauthorizedException`: Invalid credentials
- `NotFoundException`: Resource not found
- `ServerException`: Server-side errors

## 📝 Adding New Endpoints

1. Add the endpoint path to `ApiConfig`
2. Create request/response models in `models/api/`
3. Add service methods in the appropriate service class
4. Use the service in your controllers

Example:
```dart
// 1. In ApiConfig
static const String newEndpoint = '/new-feature';

// 2. In service
Future<ResponseModel> newMethod() async {
  final response = await _apiClient.get(ApiConfig.newEndpoint);
  return ResponseModel.fromJson(response.data);
}
``` 