import 'package:flutter/material.dart';
import 'bus_seating.dart'; // Import the BusSeatingPreviewScreen

class BusListScreen extends StatelessWidget {
  final String departure;
  final String destination;
  final DateTime date;

  const BusListScreen({
    super.key,
    required this.departure,
    required this.destination,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final buses = [
      {'name': 'Essaar', 'destination': 'Chennai', 'time': '9:00 AM'},
      {'name': 'YBM Travels', 'destination': 'Chennai', 'time': '11:00 AM'},
      {'name': 'KPN Travels', 'destination': 'Chennai', 'time': '1:00 PM'},
      {'name': 'A1 Travels', 'destination': 'Chennai', 'time': '4:00 PM'},
      {'name': 'Hindusthan Travels', 'destination': 'Chennai', 'time': '8:00 PM'},
      {'name': 'IntrCity SmartBus', 'destination': 'Chennai', 'time': '10:00 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Buses from $departure to $destination',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Implement refresh functionality (e.g., fetch new bus data)
            },
          ),
        ],
      ),
      body: buses.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  return _buildBusCard(context, bus);
                },
              ),
            ),
    );
  }

  Widget _buildBusCard(BuildContext context, Map<String, String> bus) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          Icons.directions_bus,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          bus['name']!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          '${bus['destination']} - ${bus['time']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to the BusSeatingPreviewScreen instead of BookingScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusSeatingPreviewScreen(
                  busName: bus['name']!,  // Pass bus name
                  departure: departure,   // Pass departure
                  destination: destination, // Pass destination
                  travelDate: date,       // Pass travel date
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
