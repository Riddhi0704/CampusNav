import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _isSaving = false;

  String _name = 'Admin';
  String _email = '';
  String _role = 'admin';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadProfile() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!mounted) return;

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        setState(() {
          _name = data['name']?.toString() ??
              user.displayName ??
              'Admin';

          _email = data['email']?.toString() ??
              user.email ??
              '';

          _role = data['role']?.toString() ?? 'admin';

          _isLoading = false;
        });
      } else {
        setState(() {
          _name = user.displayName ?? 'Admin';
          _email = user.email ?? '';
          _role = 'admin';
          _isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Firebase error: ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load profile: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<bool> _saveProfile({
    required String newName,
    required String newEmail,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not logged in.'),
        ),
      );

      return false;
    }

    try {
      final String oldEmail = user.email ?? '';

      // --------------------------------------------------------
      // UPDATE NAME IN FIREBASE AUTH
      // --------------------------------------------------------

      if (newName != (user.displayName ?? '')) {
        await user.updateDisplayName(newName);
      }

      // --------------------------------------------------------
      // UPDATE EMAIL IN FIREBASE AUTH
      // --------------------------------------------------------

      if (newEmail != oldEmail) {
        try {
          await user.verifyBeforeUpdateEmail(newEmail);
        } on FirebaseAuthException catch (e) {
          if (!mounted) return false;

          String message;

          if (e.code == 'requires-recent-login') {
            message =
                'Please logout and login again before changing your email.';
          } else if (e.code == 'email-already-in-use') {
            message = 'This email is already being used.';
          } else if (e.code == 'invalid-email') {
            message = 'Please enter a valid email address.';
          } else {
            message = e.message ?? 'Failed to update email.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 4),
            ),
          );

          return false;
        }
      }

      // --------------------------------------------------------
      // UPDATE FIRESTORE
      // --------------------------------------------------------

      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'name': newName,
          'email': newEmail,
          'role': _role,
        },
        SetOptions(merge: true),
      );

      // --------------------------------------------------------
      // RELOAD USER
      // --------------------------------------------------------

      await user.reload();

      if (!mounted) return false;

      setState(() {
        _name = newName;
        _email = newEmail;
      });

      return true;
    } on FirebaseException catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Firebase error: ${e.message ?? e.code}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      return false;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile: $e',
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      return false;
    }
  }

  // ============================================================
  // EDIT PROFILE DIALOG
  // ============================================================

  void _showEditProfileDialog() {
    final TextEditingController nameController =
        TextEditingController(text: _name);

    final TextEditingController emailController =
        TextEditingController(text: _email);

    bool saving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (
            BuildContext dialogContext,
            StateSetter setDialogState,
          ) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              title: const Text(
                'Edit Admin Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172554),
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // NAME
                    TextField(
                      controller: nameController,
                      enabled: !saving,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      enabled: !saving,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // USER TYPE - READ ONLY
                    TextField(
                      enabled: false,
                      controller: TextEditingController(
                        text: _formatRole(_role),
                      ),
                      decoration: InputDecoration(
                        labelText: 'User Type',
                        prefixIcon: const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'User Type cannot be changed from this profile.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: saving
                      ? null
                      : () async {
                          final String newName =
                              nameController.text.trim();

                          final String newEmail =
                              emailController.text.trim();

                          // VALIDATE NAME
                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(dialogContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your name.',
                                ),
                              ),
                            );
                            return;
                          }

                          // VALIDATE EMAIL
                          if (newEmail.isEmpty) {
                            ScaffoldMessenger.of(dialogContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your email.',
                                ),
                              ),
                            );
                            return;
                          }

                          final RegExp emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );

                          if (!emailRegex.hasMatch(newEmail)) {
                            ScaffoldMessenger.of(dialogContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a valid email address.',
                                ),
                              ),
                            );
                            return;
                          }

                          if (newName == _name &&
                              newEmail == _email) {
                            Navigator.of(dialogContext).pop();
                            return;
                          }

                          setDialogState(() {
                            saving = true;
                          });

                          setState(() {
                            _isSaving = true;
                          });

                          final bool success =
                              await _saveProfile(
                            newName: newName,
                            newEmail: newEmail,
                          );

                          if (!dialogContext.mounted) return;

                          if (success) {
                            Navigator.of(dialogContext).pop();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  newEmail != _email
                                      ? 'Profile updated successfully!'
                                      : 'Profile updated successfully!',
                                ),
                                duration:
                                    const Duration(seconds: 3),
                              ),
                            );
                          } else {
                            setDialogState(() {
                              saving = false;
                            });

                            if (mounted) {
                              setState(() {
                                _isSaving = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    });
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    try {
      await _auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logout failed: ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logout failed: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // LOGOUT CONFIRMATION
  // ============================================================

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),

          content: const Text(
            'Are you sure you want to logout?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT ROLE
  // ============================================================

  String _formatRole(String role) {
    if (role.isEmpty) {
      return 'Admin';
    }

    return role[0].toUpperCase() +
        role.substring(1).toLowerCase();
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value.isEmpty ? 'Not available' : value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172554),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Admin Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ADMIN AVATAR
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 65,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // NAME
                  Text(
                    _name.isEmpty ? 'Admin' : _name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // EMAIL
                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // PROFILE INFORMATION
                  Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _infoItem(
                            icon: Icons.person_outline,
                            title: 'Name',
                            value: _name,
                          ),

                          const Divider(height: 30),

                          _infoItem(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: _email,
                          ),

                          const Divider(height: 30),

                          _infoItem(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'User Type',
                            value: _formatRole(_role),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // EDIT PROFILE
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : _showEditProfileDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}