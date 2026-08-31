import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Image.asset(
                'assets/campusnav_logo.png',
                width: 180,
              ),

              const SizedBox(height: 20),

              const Text(
                'Welcome to CampusNav',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2940),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Navigate your campus with ease',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 35),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrScannerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Smart Campus Navigation',
                style: TextStyle(
                  color: Color(0xFF123A5A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}