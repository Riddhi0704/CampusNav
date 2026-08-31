import 'package:flutter/material.dart';

class NavigationScreen extends StatelessWidget {
  final String currentLocation;
  final String destination;
  final List<String> directions;
  final String distance;
  final String estimatedTime;

  const NavigationScreen({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.directions,
    required this.distance,
    required this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURRENT LOCATION',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    currentLocation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2940),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.arrow_downward,
                      color: Color(0xFFF58220),
                    ),
                  ),

                  const Text(
                    'DESTINATION',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    destination,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2940),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.straighten,
                    title: 'Distance',
                    value: distance,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.access_time,
                    title: 'Time',
                    value: estimatedTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Step-by-Step Directions',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2940),
              ),
            ),

            const SizedBox(height: 16),

            ...List.generate(
              directions.length,
                  (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF123A5A),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            directions[index],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 42,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Route Ready',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Follow the directions to reach your destination.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFFF58220),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2940),
              ),
            ),
          ],
        ),
      ),
    );
  }
}