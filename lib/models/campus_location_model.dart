class CampusLocation {
  final String id;
  final String name;
  final String description;
  final String category;
  final String building;
  final String floor;
  final double latitude;
  final double longitude;

  CampusLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.building,
    required this.floor,
    required this.latitude,
    required this.longitude,
  });

  // Convert Firestore data into CampusLocation
  factory CampusLocation.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return CampusLocation(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      building: data['building'] ?? '',
      floor: data['floor'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }

  // Convert CampusLocation into Firestore data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'building': building,
      'floor': floor,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}