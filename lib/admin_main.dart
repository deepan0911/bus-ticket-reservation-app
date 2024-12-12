import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/admin/admin_panel.dart';
import 'screens/admin/admin_home_page.dart';
import 'screens/admin/admin_booking_screen.dart';
import 'screens/admin/admin_add_bus_screen.dart';
import 'screens/admin/admin_login_screen.dart'; 

void main() async {
  // Ensure MongoDB connection before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // await MongoDBService.connect();  // Connect to MongoDB before the app starts
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/checkLogin',  // Check login status initially
      routes: {
        '/login': (context) => const AdminLoginScreen(), // Add your login screen
        '/checkLogin': (context) => const AuthCheck(),
        '/admin_panel': (context) => const AdminPanel(),
        '/home': (context) => AdminHomePage(),
        '/booking': (context) => const AdminBookingScreen(bookingId: '123'),
        '/add_bus': (context) => const AdminAddBusScreen(),
      },
    );
  }
}

// AuthCheck widget that checks the login status on app start
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoggedIn = false;
  bool _isMongoConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // Initialize MongoDB connection and check login status
  Future<void> _initializeApp() async {
    // Wait for MongoDB to connect
    // await MongoDBService.connect();

    // Check login status in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  // Default to false if not set

    if (isLoggedIn) {
      // If logged in, navigate to the Admin Panel
      Navigator.pushReplacementNamed(context, '/admin_panel');
    } else {
      // Otherwise, navigate to the login page
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isMongoConnected
            ? CircularProgressIndicator()  // Show loading spinner while checking login status
            : CircularProgressIndicator(),
      ),
    );
  }
}
