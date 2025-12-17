import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home',
              style: context.textStyles.displayLarge.copyWith(
                color: context.colors.roseRed,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to NostrDR',
              style: context.textStyles.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
