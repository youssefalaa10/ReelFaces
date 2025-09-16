import 'package:flutter/material.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/image_viewer/ui/image_viewer_screen.dart';
import '../../features/person_details/ui/person_details_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case Routes.personDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            args['personId'] == null ||
            args['personName'] == null) {
          return _errorRoute(
            settings,
            'Missing required arguments for PersonDetailsScreen',
          );
        }
        return MaterialPageRoute<dynamic>(
          builder: (_) => PersonDetailsScreen(
            personId: args['personId'] as int,
            personName: args['personName'] as String,
          ),
          settings: settings,
        );

      case Routes.imageViewerScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['imageUrl'] == null) {
          return _errorRoute(
            settings,
            'Missing required arguments for ImageViewerScreen',
          );
        }
        return MaterialPageRoute<dynamic>(
          builder: (_) => ImageViewerScreen(
            imageUrl: args['imageUrl'] as String,
            imageTitle: args['imageTitle'] as String?,
          ),
          settings: settings,
        );

      default:
        return _errorRoute(settings, 'Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Navigation Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }
}
