  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:go_router/go_router.dart';

  import '../../../core/api/providers.dart';
  import '../../../shared/l10n/app_localizations.dart';
  import '../../auth/presentation/auth_controller.dart';
  import '../../scanner/presentation/history_tab.dart';
  import '../../scanner/presentation/scan_tab.dart';

  class HomeShell extends ConsumerStatefulWidget {
    const HomeShell({super.key});
    @override
    ConsumerState<HomeShell> createState() => _HomeShellState();
  }

  class _HomeShellState extends ConsumerState<HomeShell> {
    int _index = 0;

    @override
    Widget build(BuildContext context) {
      final s = AppLocalizations.of(context);
      final pages = [
const ScanTab(),
const HistoryTab()
      ];
      final destinations = [
    NavigationDestination(icon: const Icon(Icons.qr_code_scanner), label: s.tab0Label),
    NavigationDestination(icon: const Icon(Icons.history), label: s.tab1Label)
      ];
      return Scaffold(
        appBar: AppBar(
          title: Text(s.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.business_outlined),
              tooltip: s.workspace,
              onPressed: () => _switchWorkspace(context),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: s.logout,
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: destinations,
        ),
      );
    }

    Future<void> _switchWorkspace(BuildContext context) async {
      final s = AppLocalizations.of(context);
      final ok = await showDialog<bool>(
        context: context,
        builder: (dctx) => AlertDialog(
          content: Text(s.changeWorkspaceConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dctx).pop(false),
              child: Text(s.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(dctx).pop(true),
              child: Text(s.changeWorkspace),
            ),
          ],
        ),
      );
      if (ok != true) return;
      await ref.read(authControllerProvider.notifier).logout();
      await ref.read(tenantStorageProvider).clear();
      ref.invalidate(tenantBaseUrlProvider);
      if (context.mounted) context.go('/tenant');
    }
  }
