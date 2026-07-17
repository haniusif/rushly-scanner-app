import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../data/scan_history_store.dart';
import '../data/scanner_repository.dart';
import '../domain/action_catalog.dart';
import '../domain/scanned_parcel.dart';
import 'scanner_page.dart';

class ScanTab extends ConsumerStatefulWidget {
  const ScanTab({super.key});
  @override
  ConsumerState<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends ConsumerState<ScanTab> {
  final _ctrl = TextEditingController();
  ScannedParcel? _parcel;
  bool _busy = false;
  String? _error;

  Future<void> _lookup(String code) async {
    if (code.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final p = await ref.read(scannerRepositoryProvider).lookup(code);
    if (!mounted) return;
    if (p == null) {
      setState(() {
        _busy = false;
        _parcel = null;
        _error = '${AppLocalizations.of(context).notFound}: $code';
      });
      await ref.read(scanHistoryProvider.notifier).add(ScanHistoryEntry(
            trackingId: code,
            scannedAt: DateTime.now(),
            parcelId: null,
            statusAtScan: null,
            actionTaken: null,
          ));
      return;
    }
    setState(() {
      _busy = false;
      _parcel = p;
    });
    await ref.read(scanHistoryProvider.notifier).add(ScanHistoryEntry(
          trackingId: p.trackingId,
          scannedAt: DateTime.now(),
          parcelId: p.id,
          statusAtScan: p.status,
          actionTaken: null,
        ));
  }

  Future<void> _openScanner() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );
    if (code != null) {
      _ctrl.text = code;
      await _lookup(code);
    }
  }

  Future<void> _applyAction(ScanAction action) async {
    if (_parcel == null) return;
    final s = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(action.label),
        content: Text('${_parcel!.trackingId}\n${s.confirmAction}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dctx).pop(true),
            child: Text(s.confirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(scannerRepositoryProvider).setStatus(
            parcelId: _parcel!.id,
            status: action.status,
            note: 'Scanner: ${action.label}',
          );
      await ref.read(scanHistoryProvider.notifier).add(ScanHistoryEntry(
            trackingId: _parcel!.trackingId,
            scannedAt: DateTime.now(),
            parcelId: _parcel!.id,
            statusAtScan: _parcel!.status,
            actionTaken: action.label,
          ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.applied)),
      );
      await _lookup(_parcel!.trackingId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      labelText: s.scanOrType,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: _lookup,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _busy ? null : () => _lookup(_ctrl.text.trim()),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!,
                  style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: _parcel == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.qr_code_scanner,
                            size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(s.tab0Desc,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _ParcelCard(parcel: _parcel!),
                        const SizedBox(height: 12),
                        _ActionStrip(
                          parcel: _parcel!,
                          onTap: _busy ? null : _applyAction,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openScanner,
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(s.scan),
      ),
    );
  }
}

class _ParcelCard extends StatelessWidget {
  const _ParcelCard({required this.parcel});
  final ScannedParcel parcel;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parcel.trackingId,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Chip(
              label: Text(ParcelStatus.label(parcel.status),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              backgroundColor: Colors.deepOrange.withOpacity(0.15),
            ),
            const Divider(),
            if (parcel.customerName != null)
              _Row(label: s.customer, value: parcel.customerName!),
            if (parcel.customerCity != null)
              _Row(label: s.city, value: parcel.customerCity!),
            if (parcel.customerArea != null)
              _Row(label: s.area, value: parcel.customerArea!),
            if (parcel.merchantName != null)
              _Row(label: s.merchant, value: parcel.merchantName!),
            if (parcel.destinationHub != null)
              _Row(label: s.destination, value: parcel.destinationHub!),
            if (parcel.currentHubName != null)
              _Row(label: s.currentHub, value: parcel.currentHubName!),
            if (parcel.cashCollection > 0)
              _Row(
                label: s.cod,
                value: parcel.cashCollection.toStringAsFixed(2),
                highlight: Colors.teal,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionStrip extends StatelessWidget {
  const _ActionStrip({required this.parcel, required this.onTap});
  final ScannedParcel parcel;
  final Future<void> Function(ScanAction)? onTap;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final actions = actionsFor(parcel.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.suggestedActions,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey.shade700)),
            const SizedBox(height: 8),
            if (actions.isEmpty)
              Text(s.noSuggestedActions,
                  style:
                      const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: actions
                    .map((a) => FilledButton.icon(
                          onPressed:
                              onTap == null ? null : () => onTap!(a),
                          icon: Icon(a.icon),
                          label: Text(a.label),
                          style: FilledButton.styleFrom(
                              backgroundColor: a.color),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.highlight});
  final String label;
  final String value;
  final Color? highlight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: highlight != null ? FontWeight.w700 : FontWeight.w400,
                color: highlight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
