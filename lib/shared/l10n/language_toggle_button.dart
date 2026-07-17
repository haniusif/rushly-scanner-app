import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_controller.dart';

class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic =
        ref.watch(localeProvider).languageCode == 'ar';
    return TextButton.icon(
      onPressed: () => ref.read(localeProvider.notifier).toggle(),
      icon: const Icon(Icons.translate, size: 20),
      label: Text(isArabic ? 'English' : 'العربية'),
    );
  }
}
