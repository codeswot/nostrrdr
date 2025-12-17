import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';
import 'package:nostrrdr/src/core/presentation/responsive_view.dart';

@RoutePage()
class HomeScreen extends ResponsiveView {
  const HomeScreen({super.key});

  @override
  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colors.primary.withOpacity(0.1),
                child: Text('${index + 1}'),
              ),
              title: Text(
                'Note ${index + 1}',
                style: context.textStyles.titleMedium,
              ),
              subtitle: Text(
                'This is a sample note description for mobile view.',
                style: context.textStyles.bodyMedium,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Content Area (Grid)
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note ${index + 1}',
                          style: context.textStyles.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            'This is a richer card view optimized for desktop screens with more processing power and screen real estate.',
                            style: context.textStyles.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Read More"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Sidebar Information Panel (Desktop Only)
          const VerticalDivider(width: 1),
          Expanded(
            flex: 1,
            child: Container(
              color: context.colors.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trends", style: context.textStyles.headlineSmall),
                  const Divider(),
                  const ListTile(title: Text("#Bitcoin")),
                  const ListTile(title: Text("#Nostr")),
                  const ListTile(title: Text("#Flutter")),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Create Note"),
      ),
    );
  }
}
