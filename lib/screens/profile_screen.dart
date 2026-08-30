import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;

  String _name = '';
  String _email = '';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ==========================================================
  // LOAD PROFILE
  // ==========================================================

  Future<void> _loadProfile() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        return;
      }

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (doc.exists) {
        final data = doc.data();

        setState(() {
          _name =
              data?['name']?.toString() ??
              user.displayName ??
              'User';

          _email =
              data?['email']?.toString() ??
              user.email ??
              '';

          _role =
              data?['role']?.toString() ??
              'student';

          _isLoading = false;
        });
      } else {
        setState(() {
          _name = user.displayName ?? 'User';
          _email = user.email ?? '';
          _role = 'student';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: $e'),
        ),
      );
    }
  }

  // ==========================================================
  // UPDATE PROFILE
  // ==========================================================

  Future<void> _updateProfile({
    required String newName,
    required String newEmail,
    required String newRole,
    required BuildContext dialogContext,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!dialogContext.mounted) return;

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text('You are not logged in.'),
        ),
      );

      return;
    }

    try {
      // ------------------------------------------------------
      // Update Firebase Authentication email
      // ------------------------------------------------------

      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      // ------------------------------------------------------
      // Update Firebase Auth display name
      // ------------------------------------------------------

      if (newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      // ------------------------------------------------------
      // Update Firestore profile
      // ------------------------------------------------------

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': newName,
          'email': newEmail,
          'role': newRole,
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      setState(() {
        _name = newName;
        _email = newEmail;
        _role = newRole;
      });

      // Close dialog
      if (dialogContext.mounted) {
        Navigator.of(dialogContext).pop();
      }

      if (!mounted) return;

      String message = 'Profile updated successfully!';

      if (newEmail != user.email) {
        message =
            'Profile updated. Please verify your new email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!dialogContext.mounted) return;

      String message;

      switch (e.code) {
        case 'requires-recent-login':
          message =
              'Please logout and login again before changing your email.';
          break;

        case 'email-already-in-use':
          message =
              'This email is already being used by another account.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'network-request-failed':
          message =
              'Network error. Please check your internet connection.';
          break;

        default:
          message =
              'Firebase error: ${e.message ?? e.code}';
      }

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4),
        ),
      );
    } on FirebaseException catch (e) {
      if (!dialogContext.mounted) return;

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(
            'Firebase error: ${e.message ?? e.code}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!dialogContext.mounted) return;

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile: $e',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // ==========================================================
  // EDIT PROFILE DIALOG
  // ==========================================================

  void _showEditProfileDialog() {
    final nameController = TextEditingController(
      text: _name,
    );

    final emailController = TextEditingController(
      text: _email,
    );

    String selectedRole =
        _role.isEmpty ? 'student' : _role.toLowerCase();

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool saving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172554),
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ------------------------------------------------
                    // NAME
                    // ------------------------------------------------

                    TextField(
                      controller: nameController,
                      textCapitalization:
                          TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF2563EB),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ------------------------------------------------
                    // EMAIL
                    // ------------------------------------------------

                    TextField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF2563EB),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ------------------------------------------------
                    // USER TYPE
                    // ------------------------------------------------

                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      decoration: InputDecoration(
                        labelText: 'User Type',
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF2563EB),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text('Student'),
                        ),
                        DropdownMenuItem(
                          value: 'faculty',
                          child: Text('Faculty'),
                        ),
                        DropdownMenuItem(
                          value: 'visitor',
                          child: Text('Visitor'),
                        ),
                      ],
                      onChanged: saving
                          ? null
                          : (value) {
                              if (value != null) {
                                setDialogState(() {
                                  selectedRole = value;
                                });
                              }
                            },
                    ),
                  ],
                ),
              ),

              actions: [
                // ------------------------------------------------
                // CANCEL
                // ------------------------------------------------

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

                // ------------------------------------------------
                // SAVE
                // ------------------------------------------------

                ElevatedButton(
                  onPressed: saving
                      ? null
                      : () async {
                          final newName =
                              nameController.text.trim();

                          final newEmail =
                              emailController.text.trim();

                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(
                              dialogContext,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your name.',
                                ),
                              ),
                            );

                            return;
                          }

                          if (newEmail.isEmpty) {
                            ScaffoldMessenger.of(
                              dialogContext,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your email.',
                                ),
                              ),
                            );

                            return;
                          }

                          if (!newEmail.contains('@')) {
                            ScaffoldMessenger.of(
                              dialogContext,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a valid email.',
                                ),
                              ),
                            );

                            return;
                          }

                          setDialogState(() {
                            saving = true;
                          });

                          await _updateProfile(
                            newName: newName,
                            newEmail: newEmail,
                            newRole: selectedRole,
                            dialogContext: dialogContext,
                          );

                          if (dialogContext.mounted) {
                            setDialogState(() {
                              saving = false;
                            });
                          }
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
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
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

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

  // ==========================================================
  // LOGOUT CONFIRMATION
  // ==========================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
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
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // FORMAT ROLE
  // ==========================================================

  String _formatRole(String role) {
    if (role.isEmpty) {
      return 'Student';
    }

    return role[0].toUpperCase() +
        role.substring(1).toLowerCase();
  }

  // ==========================================================
  // PROFILE INFORMATION ITEM
  // ==========================================================

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2563EB),
            size: 24,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
                value.isEmpty
                    ? 'Not available'
                    : value,
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

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF172554),
        elevation: 0,
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color: Color(0xFF2563EB),
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // PROFILE AVATAR
                  // ------------------------------------------------

                  Container(
                    width: 115,
                    height: 115,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            const Color(0xFF2563EB),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 65,
                      color:
                          Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ------------------------------------------------
                  // NAME
                  // ------------------------------------------------

                  Text(
                    _name.isEmpty
                        ? 'User'
                        : _name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF172554),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // EMAIL
                  // ------------------------------------------------

                  Text(
                    _email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ------------------------------------------------
                  // PROFILE INFORMATION
                  // ------------------------------------------------

                  Card(
                    elevation: 2,
                    color: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _profileItem(
                            icon:
                                Icons.person_outline,
                            title: 'Name',
                            value: _name,
                          ),

                          const Divider(
                            height: 28,
                          ),

                          _profileItem(
                            icon:
                                Icons.email_outlined,
                            title: 'Email',
                            value: _email,
                          ),

                          const Divider(
                            height: 28,
                          ),

                          _profileItem(
                            icon:
                                Icons.badge_outlined,
                            title: 'User Type',
                            value:
                                _formatRole(_role),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ------------------------------------------------
                  // EDIT PROFILE
                  // ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          _showEditProfileDialog,
                      icon:
                          const Icon(Icons.edit),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2563EB),
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ------------------------------------------------
                  // LOGOUT
                  // ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child:
                        OutlinedButton.icon(
                      onPressed:
                          _showLogoutDialog,
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style:
                          OutlinedButton.styleFrom(
                        side:
                            const BorderSide(
                          color: Colors.red,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  14),
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