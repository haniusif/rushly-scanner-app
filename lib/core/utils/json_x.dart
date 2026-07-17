int? asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

int asInt(dynamic v, {int fallback = 0}) => asIntOrNull(v) ?? fallback;

double? asDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.replaceAll(',', ''));
  return null;
}

double asDouble(dynamic v, {double fallback = 0}) =>
    asDoubleOrNull(v) ?? fallback;

String? asStringOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

String asString(dynamic v, {String fallback = ''}) =>
    asStringOrNull(v) ?? fallback;

List<Map<String, dynamic>> asListOfMaps(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}
