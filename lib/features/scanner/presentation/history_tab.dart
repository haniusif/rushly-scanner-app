import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../data/scan_history_store.dart';
import '../domain/action_catalog.dart';
import '../domain/scanned_parcel.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final rows = ref.watch(scanHistoryProvider);
    return Scaffold(
      body: rows.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(s.noHistory,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _HistoryTile(entry: rows[i]),
            ),
      floatingActionButton: rows.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _confirmClear(context, ref),
              icon: const Icon(Icons.delete_outline),
              label: Text(s.clearHistory),
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});
  final ScanHistoryEntry entry;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final subtitle = [
      if (entry.statusAtScan != null) ParcelStatus.label(entry.statusAtScan!),
      DateFormat.MMMd().add_Hm().format(entry.scannedAt),
    ].join(' • ');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: entry.parcelId == null
            ? Colors.red.withOpacity(0.15)
            : Colors.deepOrange.withOpacity(0.15),
        child: Icon(
          entry.parcelId == null
              ? Icons.error_outline
              : (entry.actionTaken == null ? Icons.search : Icons.check),
          color: entry.parcelId == null ? Colors.red : Colors.deepOrange,
        ),
      ),
      title: Text(entry.trackingId,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: entry.parcelId == null
          ? Text(s.notFound,
              style: const TextStyle(color: Colors.red, fontSize: 12))
          : Text(entry.actionTaken ?? s.lookupOnly,
              style: TextStyle(
                fontSize: 12,
                fontWeight: entry.actionTaken != null
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: entry.actionTaken != null ? Colors.green : Colors.grey,
              )),
    );
  }
}

Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
  final s = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (dctx) => AlertDialog(
      content: Text(s.clearHistoryConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dctx).pop(false),
          child: Text(s.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(dctx).pop(true),
          child: Text(s.clear),
        ),
      ],
    ),
  );
  if (ok == true) {
    await ref.read(scanHistoryProvider.notifier).clear();
  }
}
