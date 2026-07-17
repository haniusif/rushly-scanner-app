import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/scanned_parcel.dart';

/// Device-local scan history, capped at 100 entries (FIFO).
class ScanHistoryStore extends StateNotifier<List<ScanHistoryEntry>> {
  ScanHistoryStore() : super(const []) {
    _load();
  }

  static const _key = 'scan_history_v1';
  static const _cap = 100;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List)
          .whereType<Map>()
          .map((e) => ScanHistoryEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      state = list;
    } catch (_) {}
  }

  Future<void> add(ScanHistoryEntry entry) async {
    final next = [entry, ...state.where((e) => !_same(e, entry))];
    state = next.length > _cap ? next.sublist(0, _cap) : next;
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  bool _same(ScanHistoryEntry a, ScanHistoryEntry b) =>
      a.trackingId == b.trackingId &&
      a.scannedAt.difference(b.scannedAt).abs() < const Duration(seconds: 30);
}

final scanHistoryProvider =
    StateNotifierProvider<ScanHistoryStore, List<ScanHistoryEntry>>(
  (ref) => ScanHistoryStore(),
);
