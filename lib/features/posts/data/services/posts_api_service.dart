import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/http_service.dart';
import '../models/post_model.dart';

/// API service for posts CRUD operations
class PostsApiService {
  final HttpService _httpService;
  
  /// Creates a PostsApiService instance
  const PostsApiService(this._httpService);
  
  /// Fetches all posts from the API
  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await _httpService.get(ApiConstants.postsEndpoint);
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
  
  /// Fetches a single post by ID
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await _httpService.get(ApiConstants.postEndpoint(id));
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch post with id $id: $e');
    }
  }
  
  /// Creates a new post
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await _httpService.post(
        ApiConstants.postsEndpoint,
        data: post.toJson(),
      );
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
  
  /// Updates an existing post
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await _httpService.put(
        ApiConstants.postEndpoint(post.id),
        data: post.toJson(),
      );
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update post with id ${post.id}: $e');
    }
  }
  
  /// Deletes a post by ID
  Future<void> deletePost(int id) async {
    try {
      await _httpService.delete(ApiConstants.postEndpoint(id));
    } catch (e) {
      throw Exception('Failed to delete post with id $id: $e');
    }
  }
}