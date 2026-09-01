import 'package:flutter/material.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> locations = [
  {
    'name': 'Main Building',
    'icon': Icons.school,
    'description': 'Main college building',
  },
  {
    'name': 'Computer Lab 204',
    'icon': Icons.computer,
    'description': 'Computer Engineering Department • 2nd Floor • Room 204',
  },
  {
    'name': 'Physics Lab',
    'icon': Icons.science,
    'description': 'Physics Department • Science Block',
  },
  {
    'name': 'Electronics Lab',
    'icon': Icons.memory,
    'description': 'Electronics Department • 1st Floor',
  },
  {
    'name': 'Library',
    'icon': Icons.local_library,
    'description': 'College Library • Ground Floor',
  },
  {
    'name': 'Admin Office',
    'icon': Icons.business,
    'description': 'Administration Office • Main Building',
  },
  {
    'name': 'Canteen',
    'icon': Icons.restaurant,
    'description': 'College Canteen • Ground Floor',
  },
  {
    'name': 'Auditorium',
    'icon': Icons.theater_comedy,
    'description': 'College Auditorium • Main Campus',
  },
  {
    'name': 'Parking',
    'icon': Icons.local_parking,
    'description': 'Student Parking Area',
  },
  {
    'name': 'Washroom',
    'icon': Icons.wc,
    'description': 'Common Washroom • Main Building',
  },
  {
    'name': 'Computer Engineering Department',
    'icon': Icons.computer,
    'description': 'Computer Engineering Department • Main Block',
  },
  {
    'name': 'Mechanical Department',
    'icon': Icons.engineering,
    'description': 'Mechanical Engineering Department • Main Block',
  },
  {
    'name': 'Classrooms',
    'icon': Icons.meeting_room,
    'description': 'General classrooms • Main Block',
  },
];

  List<Map<String, dynamic>> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    filteredLocations = locations;
  }

  void searchLocation(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLocations = locations;
      } else {
        filteredLocations = locations
            .where(
              (location) => location['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void showLocationDetails(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
  location['icon'],
  color: CampusNavColors.teal,
),
              const SizedBox(width: 10),
              Expanded(
  child: Text(
    location['name'],
    style: const TextStyle(
      color: CampusNavColors.navy,
      fontWeight: FontWeight.bold,
    ),
  ),
),
            ],
          ),
          content: Text(location['description']),
          actions: [
  TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text(
  'Close',
  style: TextStyle(
    color: CampusNavColors.amber,
  ),
),
  ),

  ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: CampusNavColors.navy,
    foregroundColor: CampusNavColors.white,
  ),
  onPressed: () {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
  'Directions selected.',
),
        ),
      );
    },
    icon: const Icon(Icons.directions),
    label: const Text('Get Directions'),
  ),
],
        );
      },
    );
  }

  void showCampusMap() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Campus Map'),
        content: SizedBox(
          height: 450,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: InteractiveViewer(
              minScale: 0.6,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(50),
              child: SizedBox(
                width: 420,
                height: 700,
                child: Stack(
                  children: [
                    // Horizontal road
                    Positioned(
                      top: 300,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                    ),

                    // Vertical road
                    Positioned(
                      left: 190,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 40,
                        color: Colors.grey.shade300,
                      ),
                    ),
// Current location
Positioned(
  left: 165,
  top: 325,
  child: Column(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blue,
            width: 3,
          ),
        ),
        child: const Icon(
          Icons.my_location,
          size: 28,
          color: Colors.blue,
        ),
      ),

      const SizedBox(height: 4),

      const Text(
        'You are here',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),
                    // Buildings
                    _building(
                      'Main Building',
                      Icons.school,
                      20,
                      30,
                    ),

                    _building(
                      'Computer Lab',
                      Icons.computer,
                      280,
                      30,
                    ),

                    _building(
                      'Physics Lab',
                      Icons.science,
                      20,
                      150,
                    ),

                    _building(
                      'Electronics Lab',
                      Icons.memory,
                      280,
                      150,
                    ),

                    _building(
                      'Lab 204',
                      Icons.science,
                      20,
                      270,
                    ),

                    _building(
                      'Library',
                      Icons.local_library,
                      280,
                      270,
                    ),

                    _building(
                      'Admin Office',
                      Icons.business,
                      20,
                      390,
                    ),

                    _building(
                      'Canteen',
                      Icons.restaurant,
                      280,
                      390,
                    ),

                    _building(
                      'Auditorium',
                      Icons.theater_comedy,
                      20,
                      510,
                    ),

                    _building(
                      'Parking',
                      Icons.local_parking,
                      280,
                      510,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
 Widget _building(
  String name,
  IconData icon,
  double left,
  double top,
) {
  return Positioned(
    left: left,
    top: top,
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(name),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      icon,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
  _getDepartment(name),
  style: const TextStyle(fontSize: 15),
),

const SizedBox(height: 8),

Text(
  _getBuilding(name),
  style: const TextStyle(fontSize: 15),
),

const SizedBox(height: 8),

Text(
  _getFloor(name),
  style: const TextStyle(fontSize: 15),
),

const SizedBox(height: 8),

Text(
  _getRoom(name),
  style: const TextStyle(fontSize: 15),
),

const SizedBox(height: 8),

Text(
  _getCapacity(name),
  style: const TextStyle(fontSize: 15),
),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Directions selected.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Directions'),
                ),
              ],
            );
          },
        );
      },

      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
             color: CampusNavColors.teal,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: CampusNavColors.navy,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: CampusNavColors.navy,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
String _getDepartment(String name) {
  switch (name) {
    case 'Main Building':
      return '📍 Administration Department';
    case 'Computer Lab':
    case 'Lab 204':
      return '📍 Computer Engineering Department';
    case 'Physics Lab':
      return '📍 Physics Department';
    case 'Electronics Lab':
      return '📍 Electronics Department';
    case 'Library':
      return '📍 Central Library';
    case 'Admin Office':
      return '📍 Administration';
    case 'Canteen':
      return '📍 Student Food Court';
    case 'Auditorium':
      return '📍 College Auditorium';
    case 'Parking':
      return '📍 Campus Parking Area';
    default:
      return '📍 Campus Location';
  }
}

String _getBuilding(String name) {
  switch (name) {
    case 'Main Building':
      return '🏢 Building: Main Block';
    case 'Computer Lab':
    case 'Lab 204':
    case 'Physics Lab':
    case 'Electronics Lab':
      return '🏢 Building: Science & Technology Block';
    case 'Library':
      return '🏢 Building: Library Block';
    case 'Admin Office':
      return '🏢 Building: Administration Block';
    case 'Canteen':
      return '🏢 Building: Student Block';
    case 'Auditorium':
      return '🏢 Building: Main Campus';
    case 'Parking':
      return '🏢 Building: Parking Area';
    default:
      return '🏢 Building: Main Campus';
  }
}

String _getFloor(String name) {
  switch (name) {
    case 'Lab 204':
    case 'Computer Lab':
    case 'Physics Lab':
    case 'Electronics Lab':
      return '🏬 Floor: 2nd Floor';
    case 'Library':
    case 'Canteen':
    case 'Parking':
      return '🏬 Floor: Ground Floor';
    default:
      return '🏬 Floor: Ground Floor';
  }
}

String _getRoom(String name) {
  switch (name) {
    case 'Lab 204':
      return '🚪 Room: 204';
    case 'Computer Lab':
      return '🚪 Room: 201';
    case 'Physics Lab':
      return '🚪 Room: 202';
    case 'Electronics Lab':
      return '🚪 Room: 203';
    case 'Library':
      return '🚪 Room: G01';
    case 'Admin Office':
      return '🚪 Room: G05';
    case 'Canteen':
      return '🚪 Room: G10';
    case 'Auditorium':
      return '🚪 Hall: A01';
    case 'Parking':
      return '🚪 Area: P01';
    default:
      return '🚪 Room: N/A';
  }
}

String _getCapacity(String name) {
  switch (name) {
    case 'Lab 204':
      return '👥 Capacity: 30 Students';
    case 'Computer Lab':
      return '👥 Capacity: 40 Students';
    case 'Physics Lab':
      return '👥 Capacity: 35 Students';
    case 'Electronics Lab':
      return '👥 Capacity: 35 Students';
    case 'Library':
      return '👥 Capacity: 100 Students';
    case 'Canteen':
      return '👥 Capacity: 80 Students';
    case 'Auditorium':
      return '👥 Capacity: 300 Students';
    default:
      return '👥 Capacity: N/A';
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CampusNavColors.background,
      appBar: AppBar(
  title: const Text('CampusNav'),
  centerTitle: true,
  backgroundColor: CampusNavColors.navy,
  foregroundColor: CampusNavColors.white,
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning, Student 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CampusNavColors.navy,
              ),
            ),

            const SizedBox(height: 20),

            // Search
            TextField(
              controller: _searchController,
              onChanged: searchLocation,
              decoration: InputDecoration(
                hintText: 'Search campus locations...',
                prefixIcon: const Icon(
  Icons.search,
  color: CampusNavColors.teal,
),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchLocation('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Nearby Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CampusNavColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            if (filteredLocations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No location found'),
                ),
              )
            else
              ...filteredLocations.map(
                (location) => _locationCard(location),
              ),

            const SizedBox(height: 20),

            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CampusNavColors.navy,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _quickAccessCard(
                    Icons.map,
                    'Campus Map',
                    showCampusMap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAccessCard(
                    Icons.qr_code_scanner,
                    'Scan QR',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'QR Scanner will be added later.',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Recent Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CampusNavColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Lab 204'),
            ),

            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Library'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard(
    Map<String, dynamic> location,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
      child: ListTile(
        leading: Icon(
          location['icon'],
          size: 32,
           color: CampusNavColors.teal,
        ),
        title: Text(
          location['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CampusNavColors.navy,
          ),
        ),
        subtitle: Text(
          location['description'],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: CampusNavColors.amber,
        ),
        onTap: () {
          showLocationDetails(location);
        },
      ),
    );
  }

  Widget _quickAccessCard(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 35,
                color: CampusNavColors.teal,
              ),
              const SizedBox(height: 8),
              Text(
  title,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: CampusNavColors.navy,
  ),
),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}