import '../../data/models/post_model.dart';
import '../../data/repositories/posts_repository.dart';
import '../entities/post_entity.dart';

/// Use cases for posts operations
class PostsUseCases {
  final PostsRepository _repository;
  
  /// Creates a PostsUseCases instance
  const PostsUseCases(this._repository);
  
  /// Gets all posts
  Future<List<PostEntity>> getAllPosts() async {
    try {
      final posts = await _repository.getAllPosts();
      return posts.map(_mapModelToEntity).toList();
    } catch (e) {
      throw Exception('UseCase: Failed to get all posts - $e');
    }
  }
  
  /// Gets a single post by ID
  Future<PostEntity> getPostById(int id) async {
    try {
      final post = await _repository.getPostById(id);
      return _mapModelToEntity(post);
    } catch (e) {
      throw Exception('UseCase: Failed to get post by id $id - $e');
    }
  }
  
  /// Creates a new post
  Future<PostEntity> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      // Validate input
      if (title.trim().isEmpty) {
        throw Exception('Title cannot be empty');
      }
      if (body.trim().isEmpty) {
        throw Exception('Body cannot be empty');
      }
      if (userId <= 0) {
        throw Exception('Invalid user ID');
      }
      
      final post = await _repository.createPost(
        userId: userId,
        title: title.trim(),
        body: body.trim(),
      );
      return _mapModelToEntity(post);
    } catch (e) {
      throw Exception('UseCase: Failed to create post - $e');
    }
  }
  
  /// Updates an existing post
  Future<PostEntity> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      // Validate input
      if (id <= 0) {
        throw Exception('Invalid post ID');
      }
      if (title.trim().isEmpty) {
        throw Exception('Title cannot be empty');
      }
      if (body.trim().isEmpty) {
        throw Exception('Body cannot be empty');
      }
      if (userId <= 0) {
        throw Exception('Invalid user ID');
      }
      
      final post = await _repository.updatePost(
        id: id,
        userId: userId,
        title: title.trim(),
        body: body.trim(),
      );
      return _mapModelToEntity(post);
    } catch (e) {
      throw Exception('UseCase: Failed to update post - $e');
    }
  }
  
  /// Deletes a post by ID
  Future<void> deletePost(int id) async {
    try {
      if (id <= 0) {
        throw Exception('Invalid post ID');
      }
      
      await _repository.deletePost(id);
    } catch (e) {
      throw Exception('UseCase: Failed to delete post with id $id - $e');
    }
  }
  
  /// Maps PostModel to PostEntity
  PostEntity _mapModelToEntity(PostModel model) {
    return PostEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      body: model.body,
    );
  }
}