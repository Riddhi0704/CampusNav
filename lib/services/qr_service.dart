import '../models/qr_location_model.dart';

class QrService {
  Future<QrLocationModel?> getLocationFromQr(String qrId) async {
    final locations = {
      'QR-001': QrLocationModel(
        qrId: 'QR-001',
        locationName: 'Main Block Ground Floor',
        block: 'Block A',
        floor: 'Ground Floor',
        nodeId: 'A-G-001',
      ),
      'QR-002': QrLocationModel(
        qrId: 'QR-002',
        locationName: 'Main Block First Floor',
        block: 'Block A',
        floor: 'Floor 1',
        nodeId: 'A-1-001',
      ),
      'QR-003': QrLocationModel(
        qrId: 'QR-003',
        locationName: 'Computer Lab 204',
        block: 'Block A',
        floor: 'Floor 2',
        nodeId: 'A-2-204',
      ),
    };

    return locations[qrId];
  }
}