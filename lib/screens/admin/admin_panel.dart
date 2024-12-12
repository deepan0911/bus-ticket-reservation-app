import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_add_bus_screen.dart';
import 'admin_home_page.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  // Function to log out and clear the login state
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);  // Set login state to false

    // After logout, navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,  // Center the title for a clean look
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Logout button in the AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',  // Tooltip for accessibility
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),  // Add padding for spacing
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,  // Center align buttons
            children: [
              // Admin Home Page Navigation Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');  // Navigate to the Home page
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.grey[800],  // Dark grey background
                  padding: const EdgeInsets.symmetric(vertical: 15),  // Vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),  // Slightly rounded corners
                  ),
                ),
                child: const Text(
                  'Admin Buses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,  // White text for contrast
                  ),
                ),
              ),
              const SizedBox(height: 20),  // Add space between buttons

              // Add New Bus Navigation Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_bus');  // Navigate to Add Bus page
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.grey[600],  // Lighter grey background
                  padding: const EdgeInsets.symmetric(vertical: 15),  // Vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),  // Slightly rounded corners
                  ),
                ),
                child: const Text(
                  'Add New Bus',
                  style: TextStyle(
                    color: Colors.white,  // White text
                    fontSize: 16,
                    fontWeight: FontWeight.w500,  // Medium weight for text
                  ),
                ),
              ),
              const SizedBox(height: 20),  // Add space between buttons

    
              
            ],
          ),
        ),
      ),
    );
  } 
}
