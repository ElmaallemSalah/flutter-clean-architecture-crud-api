import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/post_entity.dart';
import '../controllers/posts_controller.dart';

/// Page for creating and editing posts
class PostFormPage extends StatefulWidget {
  /// The post to edit (null for creating new post)
  final PostEntity? post;
  
  /// Creates a PostFormPage
  const PostFormPage({super.key, this.post});
  
  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  
  bool get _isEditing => widget.post != null;
  
  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
      _userIdController.text = widget.post!.userId.toString();
    } else {
      _userIdController.text = '1'; // Default user ID
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'Create Post'),
        actions: [
          Consumer<PostsController>(
            builder: (context, controller, child) {
              return TextButton(
                onPressed: controller.isLoading ? null : _savePost,
                child: controller.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Update' : 'Save'),
              );
            },
          ),
        ],
      ),
      body: Consumer<PostsController>(
        builder: (context, controller, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller.error != null) ...[
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: controller.clearError,
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                    hintText: 'Enter user ID',
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user ID';
                    }
                    final userId = int.tryParse(value);
                    if (userId == null || userId <= 0) {
                      return 'Please enter a valid user ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter post title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                    hintText: 'Enter post content',
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter post content';
                    }
                    if (value.trim().length < 10) {
                      return 'Content must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading ? null : _savePost,
                    icon: controller.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_isEditing ? Icons.update : Icons.save),
                    label: Text(_isEditing ? 'Update Post' : 'Create Post'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /// Saves the post (create or update)
  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final controller = context.read<PostsController>();
    final userId = int.parse(_userIdController.text);
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    
    bool success;
    
    if (_isEditing) {
      success = await controller.updatePost(
        id: widget.post!.id,
        userId: userId,
        title: title,
        body: body,
      );
    } else {
      success = await controller.createPost(
        userId: userId,
        title: title,
        body: body,
      );
    }
    
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Post updated successfully!' : 'Post created successfully!',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }
}