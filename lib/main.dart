import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/dependency_injection/dependency.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/utils/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await setUpDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Reel Faces',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme, // Dark theme as default
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Force dark mode
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.homeScreen,
        );
      },
    );
  }
}
