import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/campus_location_model.dart';
import 'navigation_screen.dart';

class MapScreen extends StatefulWidget {
  final CampusLocation location;

  const MapScreen({
    super.key,
    required this.location,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final location = widget.location;

    final locationPoint = LatLng(
      location.latitude,
      location.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Stack(
        children: [
          // =========================
          // MAP
          // =========================
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: locationPoint,
              initialZoom: 17,
              minZoom: 3,
              maxZoom: 19,
            ),
            children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.campus_nav',
              ),

              // Location marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: locationPoint,
                    width: 70,
                    height: 70,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              location.name,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 55,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // =========================
          // ZOOM BUTTONS
          // =========================
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _mapButton(
                  icon: Icons.add,
                  onPressed: () {
                    _mapController.move(
                      locationPoint,
                      _mapController.camera.zoom + 1,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _mapButton(
                  icon: Icons.remove,
                  onPressed: () {
                    _mapController.move(
                      locationPoint,
                      _mapController.camera.zoom - 1,
                    );
                  },
                ),
              ],
            ),
          ),

          // =========================
          // LOCATION INFORMATION CARD
          // =========================
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 8,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + icon
                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF172B5C),
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                '${location.building} • ${location.floor}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    if (location.description.isNotEmpty)
                      Text(
                        location.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),

                    const SizedBox(height: 14),

                    // Coordinates
                    Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            '${location.latitude.toStringAsFixed(4)}, '
                            '${location.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // DIRECTIONS BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                             builder: (context) => NavigationScreen(
  currentLocation: 'Current Location',
  destination: location.name,
  directions: [
    'Head towards ${location.name}',
    'Follow the campus path to your destination',
    'You have arrived at ${location.name}',
  ],
  distance: 'Distance unavailable',
  estimatedTime: 'Time unavailable',
), 
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.directions,
                        ),
                        label: const Text(
                          'Directions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // MAP CONTROL BUTTON
  // =========================
  Widget _mapButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: SizedBox(
          width: 45,
          height: 45,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
        ),
      ),
    );
  }
}