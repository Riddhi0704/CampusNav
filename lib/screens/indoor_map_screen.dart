import 'package:flutter/material.dart';
import 'navigation_screen.dart';

class IndoorMapScreen extends StatefulWidget {
  final String currentLocation;
  final String destination;

  const IndoorMapScreen({
    super.key,
    required this.currentLocation,
    required this.destination,
  });

  @override
  State<IndoorMapScreen> createState() => _IndoorMapScreenState();
}

class _IndoorMapScreenState extends State<IndoorMapScreen> {
  String selectedDestination = 'Computer Lab 204';

  final List<String> destinations = [
    'Computer Lab 204',
    'Library',
    'Lab 201',
    'Seminar Hall',
    'Main Office',
  ];

  List<String> getDirections(String destination) {
    switch (destination) {
      case 'Computer Lab 204':
        return [
          'Start from Main Block Ground Floor',
          'Walk straight through the main corridor',
          'Take the stairs to Floor 2',
          'Turn left after reaching Floor 2',
          'Continue straight for 50 meters',
          'Computer Lab 204 is on your right',
        ];

      case 'Library':
        return [
          'Walk straight from the main entrance',
          'Turn right at the central corridor',
          'Continue for 80 meters',
          'The Library is on your left',
        ];

      case 'Lab 201':
        return [
          'Walk straight through the main corridor',
          'Take the stairs to Floor 2',
          'Turn left',
          'Lab 201 is ahead',
        ];

      case 'Seminar Hall':
        return [
          'Walk straight from the main entrance',
          'Turn left at the reception area',
          'Continue for 60 meters',
          'The Seminar Hall is on your right',
        ];

      default:
        return [
          'Walk straight through the main corridor',
          'Turn right',
          'Continue for 40 meters',
          'You have reached your destination',
        ];
    }
  }

  void startNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationScreen(
          currentLocation: widget.currentLocation,
          destination: selectedDestination,
          directions: getDirections(selectedDestination),
          distance: '180 m',
          estimatedTime: '3 min',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indoor Map'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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

            const SizedBox(height: 6),

            Text(
              widget.currentLocation,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2940),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFB8D5E5),
                ),
              ),
              child: CustomPaint(
                painter: CampusMapPainter(),
                child: const Center(
                  child: Icon(
                    Icons.location_on,
                    size: 50,
                    color: Color(0xFFF58220),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Choose Destination',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2940),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedDestination,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.place),
              ),
              items: destinations.map((destination) {
                return DropdownMenuItem(
                  value: destination,
                  child: Text(destination),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDestination = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: startNavigation,
              icon: const Icon(Icons.navigation),
              label: const Text('Start Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}

class CampusMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF123A5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final roomPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final block = Rect.fromLTWH(
      25,
      25,
      size.width - 50,
      size.height - 50,
    );

    canvas.drawRect(block, roomPaint);
    canvas.drawRect(block, linePaint);

    canvas.drawLine(
      Offset(size.width / 2, 25),
      Offset(size.width / 2, size.height - 25),
      linePaint,
    );

    canvas.drawLine(
      Offset(25, size.height / 2),
      Offset(size.width - 25, size.height / 2),
      linePaint,
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'BLOCK A',
        style: TextStyle(
          color: Color(0xFF123A5A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - 35,
        size.height / 2 - 10,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}