import 'package:flutter/foundation.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/posts_usecases.dart';

/// Controller for posts state management using Provider
class PostsController extends ChangeNotifier {
  final PostsUseCases _useCases;
  
  /// Creates a PostsController instance
  PostsController(this._useCases);
  
  List<PostEntity> _posts = [];
  bool _isLoading = false;
  String? _error;
  PostEntity? _selectedPost;
  
  /// List of all posts
  List<PostEntity> get posts => _posts;
  
  /// Loading state
  bool get isLoading => _isLoading;
  
  /// Error message
  String? get error => _error;
  
  /// Currently selected post
  PostEntity? get selectedPost => _selectedPost;
  
  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Sets error message
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  /// Clears error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Loads all posts
  Future<void> loadPosts() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _posts = await _useCases.getAllPosts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  /// Loads a single post by ID
  Future<void> loadPostById(int id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      _selectedPost = await _useCases.getPostById(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  
  /// Creates a new post
  Future<bool> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final newPost = await _useCases.createPost(
        userId: userId,
        title: title,
        body: body,
      );
      
      // Add to the beginning of the list for better UX
      _posts.insert(0, newPost);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Updates an existing post
  Future<bool> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedPost = await _useCases.updatePost(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );
      
      // Update the post in the list
      final index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      
      // Update selected post if it's the same
      if (_selectedPost?.id == id) {
        _selectedPost = updatedPost;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Deletes a post by ID
  Future<bool> deletePost(int id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _useCases.deletePost(id);
      
      // Remove from the list
      _posts.removeWhere((post) => post.id == id);
      
      // Clear selected post if it's the deleted one
      if (_selectedPost?.id == id) {
        _selectedPost = null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Sets the selected post
  void setSelectedPost(PostEntity? post) {
    _selectedPost = post;
    notifyListeners();
  }
  
  /// Refreshes the posts list
  Future<void> refreshPosts() async {
    await loadPosts();
  }
}