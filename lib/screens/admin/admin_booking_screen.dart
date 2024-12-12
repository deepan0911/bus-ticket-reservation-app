// admin_booking_screen.dart
import 'package:flutter/material.dart';

class AdminBookingScreen extends StatelessWidget {
  final String bookingId;

  const AdminBookingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Booking Screen - $bookingId'),
      ),
      body: Center(
        child: Text('This is the admin booking screen for $bookingId'),
      ),
    );
  }
}
