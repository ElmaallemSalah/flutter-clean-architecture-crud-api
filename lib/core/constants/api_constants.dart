/// API constants for JSONPlaceholder service
class ApiConstants {
  /// Base URL for JSONPlaceholder API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  /// Posts endpoint
  static const String postsEndpoint = '/posts';
  
  /// Get single post endpoint
  static String postEndpoint(int id) => '/posts/$id';
  
  /// Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);
  
  /// Connection timeout duration
  static const Duration connectionTimeout = Duration(seconds: 30);
}