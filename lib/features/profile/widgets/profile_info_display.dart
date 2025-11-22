import 'package:flutter/material.dart';
import 'package:nostrrdr/core/database/database.dart';

class ProfileInfoDisplay extends StatelessWidget {
  final Profile? profile;

  const ProfileInfoDisplay({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          profile?.name ?? 'Anonymous',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (profile?.nip05 != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                profile!.nip05!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
        if (profile?.about != null) ...[
          const SizedBox(height: 16),
          Text(
            profile!.about!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
