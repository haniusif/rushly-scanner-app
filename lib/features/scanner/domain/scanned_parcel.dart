import '../../../core/utils/json_x.dart';

class ScannedParcel {
  ScannedParcel({
    required this.id,
    required this.trackingId,
    required this.customerName,
    required this.customerCity,
    required this.customerArea,
    required this.status,
    required this.currentHubId,
    required this.currentHubName,
    required this.destinationHubId,
    required this.destinationHub,
    required this.merchantName,
    required this.cashCollection,
  });

  final int id;
  final String trackingId;
  final String? customerName;
  final String? customerCity;
  final String? customerArea;
  final int status;
  final int? currentHubId;
  final String? currentHubName;
  final int? destinationHubId;
  final String? destinationHub;
  final String? merchantName;
  final double cashCollection;

  factory ScannedParcel.fromJson(Map<String, dynamic> json) => ScannedParcel(
        id: asInt(json['id']),
        trackingId: asString(json['tracking_id']),
        customerName: asStringOrNull(json['customer_name']),
        customerCity: asStringOrNull(json['customer_city']),
        customerArea: asStringOrNull(json['customer_area']),
        status: asInt(json['status']),
        currentHubId: asIntOrNull(json['current_hub_id']),
        currentHubName: asStringOrNull(json['current_hub_name']),
        destinationHubId: asIntOrNull(json['destination_hub_id']),
        destinationHub: asStringOrNull(json['destination_hub']),
        merchantName: asStringOrNull(json['merchant_name']),
        cashCollection: asDouble(json['cash_collection']),
      );
}

class ScanHistoryEntry {
  ScanHistoryEntry({
    required this.trackingId,
    required this.scannedAt,
    required this.parcelId,
    required this.statusAtScan,
    required this.actionTaken,
  });

  final String trackingId;
  final DateTime scannedAt;
  final int? parcelId;
  final int? statusAtScan;
  /// Human-readable action label (or null if lookup-only).
  final String? actionTaken;

  Map<String, dynamic> toJson() => {
        'tracking_id': trackingId,
        'scanned_at': scannedAt.toIso8601String(),
        'parcel_id': parcelId,
        'status_at_scan': statusAtScan,
        'action_taken': actionTaken,
      };

  factory ScanHistoryEntry.fromJson(Map<String, dynamic> json) =>
      ScanHistoryEntry(
        trackingId: asString(json['tracking_id']),
        scannedAt: DateTime.tryParse(asString(json['scanned_at'])) ??
            DateTime.now(),
        parcelId: asIntOrNull(json['parcel_id']),
        statusAtScan: asIntOrNull(json['status_at_scan']),
        actionTaken: asStringOrNull(json['action_taken']),
      );
}
