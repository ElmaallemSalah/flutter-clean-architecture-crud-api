import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/posts_controller.dart';
import '../widgets/post_card.dart';
import 'post_form_page.dart';
import 'post_detail_page.dart';

/// Page displaying the list of posts
class PostsListPage extends StatefulWidget {
  /// Creates a PostsListPage
  const PostsListPage({super.key});
  
  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  @override
  void initState() {
    super.initState();
    // Load posts when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsController>().loadPosts();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostsController>().refreshPosts(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<PostsController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.clearError();
                      controller.loadPosts();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (controller.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.post_add,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No posts found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first post to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToCreatePost(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Post'),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => controller.refreshPosts(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                final post = controller.posts[index];
                return PostCard(
                  post: post,
                  onTap: () => _navigateToPostDetail(context, post.id),
                  onEdit: () => _navigateToEditPost(context, post),
                  onDelete: () => _showDeleteConfirmation(context, post.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreatePost(context),
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Navigates to the post creation page
  void _navigateToCreatePost(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PostFormPage(),
      ),
    );
  }
  
  /// Navigates to the post edit page
  void _navigateToEditPost(BuildContext context, post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostFormPage(post: post),
      ),
    );
  }
  
  /// Navigates to the post detail page
  void _navigateToPostDetail(BuildContext context, int postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailPage(postId: postId),
      ),
    );
  }
  
  /// Shows delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PostsController>().deletePost(postId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}