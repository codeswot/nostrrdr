import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: CircleAvatar(
        radius: 48,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          size: 48,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
