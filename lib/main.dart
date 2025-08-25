import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/http_service.dart';
import 'core/theme/app_theme.dart';
import 'features/posts/data/services/posts_api_service.dart';
import 'features/posts/data/repositories/posts_repository.dart';
import 'features/posts/domain/usecases/posts_usecases.dart';
import 'features/posts/presentation/controllers/posts_controller.dart';
import 'features/posts/presentation/pages/posts_list_page.dart';

void main() {
  runApp(const PostsApp());
}

/// Main application widget with dependency injection
class PostsApp extends StatelessWidget {
  const PostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        Provider<HttpService>(
          create: (_) => HttpService(),
        ),
        
        // Data layer
        ProxyProvider<HttpService, PostsApiService>(
          update: (_, httpService, __) => PostsApiService(httpService),
        ),
        ProxyProvider<PostsApiService, PostsRepository>(
          update: (_, apiService, __) => PostsRepository(apiService),
        ),
        
        // Domain layer
        ProxyProvider<PostsRepository, PostsUseCases>(
          update: (_, repository, __) => PostsUseCases(repository),
        ),
        
        // Presentation layer
        ChangeNotifierProxyProvider<PostsUseCases, PostsController>(
          create: (context) => PostsController(
            context.read<PostsUseCases>(),
          ),
          update: (_, useCases, controller) => controller ?? PostsController(useCases),
        ),
      ],
      child: MaterialApp(
        title: 'Posts CRUD App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const PostsListPage(),
      ),
    );
  }
}
