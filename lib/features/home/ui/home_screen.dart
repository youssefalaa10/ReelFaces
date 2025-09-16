import 'package:flutter/material.dart';
import '../../../core/utils/styles/app_text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reel Faces', style: AppTextStyle.headlineSmall),
      ),
      body: Center(
        child: Text(
          'Welcome to Home!',
          style: AppTextStyle.bodyLarge,
        ),
      ),
    );
  }
}
