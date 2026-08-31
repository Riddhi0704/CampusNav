class QrLocationModel {
  final String qrId;
  final String locationName;
  final String block;
  final String floor;
  final String nodeId;

  QrLocationModel({
    required this.qrId,
    required this.locationName,
    required this.block,
    required this.floor,
    required this.nodeId,
  });

  factory QrLocationModel.fromMap(Map<String, dynamic> map) {
    return QrLocationModel(
      qrId: map['qrId'] ?? '',
      locationName: map['locationName'] ?? '',
      block: map['block'] ?? '',
      floor: map['floor'] ?? '',
      nodeId: map['nodeId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qrId': qrId,
      'locationName': locationName,
      'block': block,
      'floor': floor,
      'nodeId': nodeId,
    };
  }
}