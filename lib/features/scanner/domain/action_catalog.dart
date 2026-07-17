import 'package:flutter/material.dart';

/// Suggested actions per parcel status. Keeps the mapping in one place
/// so the button strip on the Scan tab and the labels on the History
/// tab stay in sync.
class ParcelStatus {
  static const pending = 1;
  static const pickupAssign = 2;
  static const pickupReSchedule = 3;
  static const receivedByPickupMan = 4;
  static const receivedWarehouse = 5;
  static const transferToHub = 6;
  static const deliveryManAssign = 7;
  static const delivered = 9;
  static const returnWarehouse = 11;
  static const returnedMerchant = 13;
  static const receivedByHub = 19;
  static const returnToCourier = 24;
  static const returnAssignToMerchant = 26;
  static const returnReceivedByMerchant = 30;
  static const wmsReadyToShip = 40;
  static const cancelled = 41;

  static String label(int s) {
    switch (s) {
      case pending: return 'Pending';
      case pickupAssign: return 'Pickup assigned';
      case pickupReSchedule: return 'Pickup rescheduled';
      case receivedByPickupMan: return 'Picked up';
      case receivedWarehouse: return 'At warehouse';
      case transferToHub: return 'In transit to hub';
      case deliveryManAssign: return 'Out for delivery';
      case delivered: return 'Delivered';
      case returnWarehouse: return 'Return in warehouse';
      case returnedMerchant: return 'Returned to merchant';
      case receivedByHub: return 'Received by hub';
      case returnToCourier: return 'Returning to courier';
      case returnAssignToMerchant: return 'Assigned back to merchant';
      case returnReceivedByMerchant: return 'Received by merchant (return)';
      case wmsReadyToShip: return 'Ready to ship';
      case cancelled: return 'Cancelled';
      default: return 'Status $s';
    }
  }
}

class ScanAction {
  const ScanAction({
    required this.label,
    required this.icon,
    required this.status,
    required this.color,
    this.confirm = true,
  });
  final String label;
  final IconData icon;
  final int status;
  final Color color;
  final bool confirm;
}

/// Given the parcel's current status, return the ranked list of
/// actions that make sense from THIS scan. Kept intentionally small.
List<ScanAction> actionsFor(int status) {
  switch (status) {
    case ParcelStatus.transferToHub:
      return const [
        ScanAction(
          label: 'Received by hub',
          icon: Icons.warehouse,
          status: ParcelStatus.receivedByHub,
          color: Colors.green,
        ),
      ];
    case ParcelStatus.pending:
    case ParcelStatus.pickupAssign:
    case ParcelStatus.pickupReSchedule:
      return const [
        ScanAction(
          label: 'Picked up',
          icon: Icons.check_circle,
          status: ParcelStatus.receivedByPickupMan,
          color: Colors.blue,
        ),
      ];
    case ParcelStatus.receivedByPickupMan:
      return const [
        ScanAction(
          label: 'At warehouse',
          icon: Icons.warehouse_outlined,
          status: ParcelStatus.receivedWarehouse,
          color: Colors.blue,
        ),
      ];
    case ParcelStatus.receivedWarehouse:
    case ParcelStatus.receivedByHub:
      return const [
        ScanAction(
          label: 'Transfer to hub',
          icon: Icons.local_shipping,
          status: ParcelStatus.transferToHub,
          color: Colors.deepPurple,
        ),
      ];
    case ParcelStatus.deliveryManAssign:
      return const [
        ScanAction(
          label: 'Delivered',
          icon: Icons.check,
          status: ParcelStatus.delivered,
          color: Colors.green,
        ),
      ];
    case ParcelStatus.returnToCourier:
    case ParcelStatus.returnAssignToMerchant:
      return const [
        ScanAction(
          label: 'Return received',
          icon: Icons.assignment_return,
          status: ParcelStatus.returnWarehouse,
          color: Colors.orange,
        ),
      ];
    default:
      return const [];
  }
}
