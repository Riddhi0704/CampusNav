import 'package:flutter/material.dart';

import 'campus_locations_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CampusNav',
          style: TextStyle(
            color: Color(0xFF172554),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF172554),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to CampusNav 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Navigate your campus with ease.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Search buildings, rooms, facilities...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF2563EB),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _quickCard(
                    context,
                    Icons.map_outlined,
                    'Campus Map',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _quickCard(
                    context,
                    Icons.location_on_outlined,
                    'Find Place',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _quickCard(
                    context,
                    Icons.directions_outlined,
                    'Directions',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _quickCard(
                    context,
                    Icons.school_outlined,
                    'Departments',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Campus Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 15),

            _serviceTile(
              Icons.local_library_outlined,
              'Library',
              'Find your campus library',
            ),

            const SizedBox(height: 12),

            _serviceTile(
              Icons.restaurant_outlined,
              'Cafeteria',
              'Find food and refreshment areas',
            ),

            const SizedBox(height: 12),

            _serviceTile(
              Icons.local_parking_outlined,
              'Parking',
              'Locate available parking areas',
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          // Places
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CampusLocationsScreen(),
              ),
            );
          }

          // Profile
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProfileScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Places',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _quickCard(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: () {
        if (title == 'Find Place') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const CampusLocationsScreen(),
            ),
          );
        }
      },

      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
              color: const Color(0xFF2563EB),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172554),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}