import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'manage_buildings_screen.dart';
import 'manage_locations_screen.dart';
import 'manage_departments_screen.dart';
import 'admin_profile_screen.dart';
import 'campus_locations_screen.dart';
import 'manage_users_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color primaryColor = const Color(0xFF2563EB);

  Stream<int> _getCollectionCount(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CampusNav Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfileScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person_outline,
            ),
          ),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin! 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your campus with CampusNav',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------------------------------
            // CAMPUS OVERVIEW
            // ----------------------------------------------------
            const Text(
              'Campus Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 15),

            // Statistics Row 1
            Row(
              children: [
                Expanded(
                  child: _buildLiveStatCard(
                    icon: Icons.business_outlined,
                    title: 'Buildings',
                    collection: 'buildings',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildLiveStatCard(
                    icon: Icons.location_on_outlined,
                    title: 'Locations',
                    collection: 'campus_locations',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Statistics Row 2
            Row(
              children: [
                Expanded(
                  child: _buildLiveStatCard(
                    icon: Icons.school_outlined,
                    title: 'Departments',
                    collection: 'departments',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildLiveStatCard(
                    icon: Icons.people_outline,
                    title: 'Users',
                    collection: 'users',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ----------------------------------------------------
            // MANAGEMENT
            // ----------------------------------------------------
            const Text(
              'Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 15),

            // Manage Buildings
            _buildManagementCard(
              icon: Icons.business_outlined,
              title: 'Manage Buildings',
              subtitle: 'Add, edit and remove buildings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ManageBuildingsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Manage Locations
            _buildManagementCard(
              icon: Icons.location_on_outlined,
              title: 'Manage Locations',
              subtitle: 'Manage campus locations',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ManageLocationsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Manage Departments
            _buildManagementCard(
              icon: Icons.school_outlined,
              title: 'Manage Departments',
              subtitle: 'Add and manage departments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ManageDepartmentsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Manage Users
            _buildManagementCard(
              icon: Icons.people_outline,
              title: 'Manage Users',
              subtitle: 'View and manage users',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ManageUsersScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Manage Campus Map
            _buildManagementCard(
              icon: Icons.map_outlined,
              title: 'Manage Campus Map',
              subtitle: 'Update campus map information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CampusLocationsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION
      // ----------------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Buildings
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ManageBuildingsScreen(),
              ),
            );
          }

          // Map
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
                    const AdminProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Buildings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
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

  // ----------------------------------------------------------
  // LIVE STATISTICS CARD
  // ----------------------------------------------------------
  Widget _buildLiveStatCard({
    required IconData icon,
    required String title,
    required String collection,
  }) {
    return StreamBuilder<int>(
      stream: _getCollectionCount(collection),
      builder: (context, snapshot) {
        String value = '...';

        if (snapshot.hasData) {
          value = snapshot.data.toString();
        }

        if (snapshot.hasError) {
          value = '!';
        }

        return _buildStatCard(
          icon: icon,
          title: title,
          value: value,
        );
      },
    );
  }

  // ----------------------------------------------------------
  // STATISTICS CARD
  // ----------------------------------------------------------
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // MANAGEMENT CARD
  // ----------------------------------------------------------
  Widget _buildManagementCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF172554),
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}