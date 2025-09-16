import 'package:flutter/material.dart';
import '../../../core/utils/styles/app_text_style.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
    required this.personId,
    required this.personName,
    super.key,
  });
  final int personId;
  final String personName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personName, style: AppTextStyle.appBarTitle),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Person Details', style: AppTextStyle.headlineMedium),
            const SizedBox(height: 8),
            Text('ID: $personId', style: AppTextStyle.bodyLarge),
            const SizedBox(height: 8),
            Text('Name: $personName', style: AppTextStyle.bodyLarge),
            const SizedBox(height: 24),
            Text(
              'This screen will show detailed information about the person.',
              style: AppTextStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
