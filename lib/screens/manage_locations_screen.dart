import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageLocationsScreen extends StatefulWidget {
  const ManageLocationsScreen({super.key});

  @override
  State<ManageLocationsScreen> createState() =>
      _ManageLocationsScreenState();
}

class _ManageLocationsScreenState
    extends State<ManageLocationsScreen> {
  final Color primaryColor = const Color(0xFF2563EB);

  Future<void> _showLocationDialog(
    BuildContext context, {
    String? documentId,
    Map<String, dynamic>? existingData,
  }) async {
    final nameController = TextEditingController(
      text: existingData?['name']?.toString() ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingData?['description']?.toString() ?? '',
    );

    final categoryController = TextEditingController(
      text: existingData?['category']?.toString() ?? '',
    );

    final buildingController = TextEditingController(
      text: existingData?['building']?.toString() ?? '',
    );

    final floorController = TextEditingController(
      text: existingData?['floor']?.toString() ?? '',
    );

    final latitudeController = TextEditingController(
      text: existingData?['latitude']?.toString() ?? '',
    );

    final longitudeController = TextEditingController(
      text: existingData?['longitude']?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            documentId == null
                ? 'Add Campus Location'
                : 'Edit Campus Location',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Location Name',
                    hintText: 'e.g. Workshop',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter location description',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g. Academic, Facility',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: buildingController,
                  decoration: const InputDecoration(
                    labelText: 'Building',
                    hintText: 'e.g. C2',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: floorController,
                  decoration: const InputDecoration(
                    labelText: 'Floor',
                    hintText: 'e.g. Ground Floor',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: latitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    hintText: 'e.g. 18.532430',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: longitudeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    hintText: 'e.g. 73.879906',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final description =
                    descriptionController.text.trim();
                final category =
                    categoryController.text.trim();
                final building =
                    buildingController.text.trim();
                final floor =
                    floorController.text.trim();

                final latitude =
                    double.tryParse(latitudeController.text.trim());

                final longitude =
                    double.tryParse(longitudeController.text.trim());

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter location name',
                      ),
                    ),
                  );
                  return;
                }

                if (latitude == null || longitude == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid latitude and longitude',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  final collection = FirebaseFirestore.instance
                      .collection('campus_locations');

                  final data = {
                    'name': name,
                    'description': description,
                    'category': category,
                    'building': building,
                    'floor': floor,

                    // Stored as strings to remain compatible
                    // with the existing campus location data.
                    'latitude': latitude.toString(),
                    'longitude': longitude.toString(),
                  };

                  if (documentId == null) {
                    await collection.add({
                      ...data,
                      'createdAt':
                          FieldValue.serverTimestamp(),
                    });
                  } else {
                    await collection.doc(documentId).update({
                      ...data,
                      'updatedAt':
                          FieldValue.serverTimestamp(),
                    });
                  }

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          documentId == null
                              ? 'Location added successfully'
                              : 'Location updated successfully',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: $e',
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text(
                documentId == null ? 'Add' : 'Update',
              ),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    buildingController.dispose();
    floorController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }

  Future<void> _deleteLocation(
    BuildContext context,
    String documentId,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Location'),
          content: Text(
            'Are you sure you want to delete "$name"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('campus_locations')
          .doc(documentId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location deleted successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting location: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      appBar: AppBar(
        title: const Text(
          'Manage Locations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showLocationDialog(context);
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add_location_alt_outlined,
        ),
        label: const Text('Add Location'),
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('campus_locations')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading locations:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          final locations = snapshot.data?.docs ?? [];

          if (locations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No locations found.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tap + to add a campus location.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final doc = locations[index];
              final data = doc.data();

              final name =
                  data['name']?.toString() ?? '';

              final description =
                  data['description']?.toString() ?? '';

              final building =
                  data['building']?.toString() ?? '';

              final floor =
                  data['floor']?.toString() ?? '';

              final category =
                  data['category']?.toString() ?? '';

              return Card(
                elevation: 2,
                color: Colors.white,
                margin:
                    const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(14),

                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF2563EB),
                      size: 28,
                    ),
                  ),

                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                        const EdgeInsets.only(top: 6),
                    child: Text(
                      '$building • Floor $floor\n'
                      '$category\n'
                      '$description',
                    ),
                  ),

                  trailing:
                      PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showLocationDialog(
                          context,
                          documentId: doc.id,
                          existingData: data,
                        );
                      }

                      if (value == 'delete') {
                        _deleteLocation(
                          context,
                          doc.id,
                          name,
                        );
                      }
                    },

                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}