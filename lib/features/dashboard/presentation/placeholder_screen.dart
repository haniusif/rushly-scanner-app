import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';

/// Reusable "coming soon" screen used by every home-shell tab in the
/// scaffolded apps. Each tab supplies its own label + description so
/// the placeholder still reads like a purposeful feature.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
  });
  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 72,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Chip(
              avatar: const Icon(Icons.build_circle_outlined, size: 18),
              label: Text(s.comingSoon),
            ),
            const SizedBox(height: 8),
            Text(s.comingSoonHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
