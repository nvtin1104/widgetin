import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';

class WidgetPreviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget preview;
  final VoidCallback? onCustomize;

  const WidgetPreviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.preview,
    this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Icon(icon, color: ColorTokens.softRed, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: ColorTokens.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Preview area
            preview,
            const SizedBox(height: 16),
            // Customize button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCustomize,
                child: const Text('Customize'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
