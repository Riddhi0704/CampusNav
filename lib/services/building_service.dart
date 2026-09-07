import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all buildings
  Stream<QuerySnapshot<Map<String, dynamic>>> getBuildings() {
    return _firestore
        .collection('buildings')
        .orderBy('name')
        .snapshots();
  }

  // Add a building
  Future<void> addBuilding({
    required String name,
    required String details,
    required int floors,
  }) async {
    await _firestore.collection('buildings').add({
      'name': name,
      'details': details,
      'floors': floors,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update a building
  Future<void> updateBuilding({
    required String id,
    required String name,
    required String details,
    required int floors,
  }) async {
    await _firestore.collection('buildings').doc(id).update({
      'name': name,
      'details': details,
      'floors': floors,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete a building
  Future<void> deleteBuilding(String id) async {
    await _firestore.collection('buildings').doc(id).delete();
  }
}
