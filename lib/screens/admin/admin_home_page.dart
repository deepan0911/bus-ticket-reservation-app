import 'package:flutter/material.dart';
import 'bus.dart';

class AdminHomePage extends StatelessWidget {
  // Example list of buses (you would ideally use a state management solution or a database)
  final List<Bus> buses = [
    Bus(name: 'Bus A', busNumber: '1234', availableSeats: 40, departureCity: 'Coimbatore', arrivalCity: 'Chennai', departureTime: null),
    Bus(name: 'Bus B', busNumber: '5678', availableSeats: 30, arrivalCity: 'Chennai', departureCity: 'Coimbatore', departureTime: null),
  ];

  AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.black, 
        foregroundColor: Colors.white, // A more neutral color for the app bar
      ),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Bus Number: ${bus.busNumber}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Available Seats: ${bus.availableSeats}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Departure City: ${bus.departureCity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Arrival City: ${bus.arrivalCity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Departure Time: ${bus.departureTime != null ? bus.departureTime : 'Not Set'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
