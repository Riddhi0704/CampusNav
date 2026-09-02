import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/campus_location_model.dart';
import '../services/firestore_service.dart';
import 'map_screen.dart';

class CampusLocationsScreen extends StatelessWidget {
  const CampusLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Locations'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getCampusLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No campus locations found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final locations = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = CampusLocation.fromMap(
                locations[index].id,
                locations[index].data(),
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF2563EB),
                      size: 28,
                    ),
                  ),
                  title: Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${location.building} • Floor ${location.floor}\n'
                      '${location.description}',
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          location: location,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}