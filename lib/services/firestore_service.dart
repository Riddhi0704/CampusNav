import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCampusLocations() {
    return _firestore.collection('campus_locations').snapshots();
  }
}