import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostrrdr/core/services/toast_service.dart';

class KeySectionCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final bool isPrivate;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;

  const KeySectionCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isPrivate = false,
    this.isVisible = true,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isPrivate
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    final containerColor = isPrivate
        ? theme.colorScheme.errorContainer.withValues(alpha: 0.3)
        : theme.colorScheme.surfaceContainerHighest;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPrivate ? color : null,
                  ),
                ),
              ],
            ),
            if (isPrivate) ...[
              const SizedBox(height: 8),
              Text(
                'Keep this secret! Never share your private key.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(8),
                border: isPrivate
                    ? Border.all(color: color.withValues(alpha: 0.3))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isVisible ? (value ?? 'Not available') : '•' * 60,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPrivate)
                    IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: value == null
                        ? null
                        : () {
                            Clipboard.setData(ClipboardData(text: value!));
                            ToastService.showSuccess(
                              context,
                              isPrivate
                                  ? 'Private key copied! Keep it safe.'
                                  : 'Public key copied!',
                            );
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
