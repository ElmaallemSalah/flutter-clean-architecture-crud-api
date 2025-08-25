import '../models/post_model.dart';
import '../services/posts_api_service.dart';

/// Repository for posts data access
class PostsRepository {
  final PostsApiService _apiService;
  
  /// Creates a PostsRepository instance
  const PostsRepository(this._apiService);
  
  /// Fetches all posts
  Future<List<PostModel>> getAllPosts() async {
    try {
      return await _apiService.getAllPosts();
    } catch (e) {
      throw Exception('Repository: Failed to get all posts - $e');
    }
  }
  
  /// Fetches a single post by ID
  Future<PostModel> getPostById(int id) async {
    try {
      return await _apiService.getPostById(id);
    } catch (e) {
      throw Exception('Repository: Failed to get post by id $id - $e');
    }
  }
  
  /// Creates a new post
  Future<PostModel> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final post = PostModel(
        id: 0, // Will be assigned by the server
        userId: userId,
        title: title,
        body: body,
      );
      return await _apiService.createPost(post);
    } catch (e) {
      throw Exception('Repository: Failed to create post - $e');
    }
  }
  
  /// Updates an existing post
  Future<PostModel> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final post = PostModel(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );
      return await _apiService.updatePost(post);
    } catch (e) {
      throw Exception('Repository: Failed to update post - $e');
    }
  }
  
  /// Deletes a post by ID
  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete post with id $id - $e');
    }
  }
}