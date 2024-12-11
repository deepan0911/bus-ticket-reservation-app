import 'package:flutter/material.dart';
import 'booking_screen.dart';  // Make sure to import the BookingScreen

class BusSeatingPreviewScreen extends StatefulWidget {
  final String busName;
  final String departure;
  final String destination;
  final DateTime travelDate;

  const BusSeatingPreviewScreen({
    super.key,
    required this.busName,
    required this.departure,
    required this.destination,
    required this.travelDate,
  });

  @override
  _BusSeatingPreviewScreenState createState() =>
      _BusSeatingPreviewScreenState();
}

class _BusSeatingPreviewScreenState extends State<BusSeatingPreviewScreen> {
  List<List<String>> seats = []; // List to store seat status (available/booked/selected)
  List<int> selectedSeats = []; // Store selected seat indices

  @override
  void initState() {
    super.initState();
    // Initialize seats: 9 rows, each with 5 seats (one aisle for the first 8 rows)
    seats = List.generate(
      9,
      (i) => List.generate(5, (j) => i == 8 ? 'A' : 'A'), // All seats available initially
    );
  }

  // Function to handle seat selection
  void toggleSeatSelection(int row, int col) {
    setState(() {
      if (seats[row][col] == 'A') {
        // Mark as selected
        seats[row][col] = 'S';
        selectedSeats.add(row * 5 + col);
      } else if (seats[row][col] == 'S') {
        // Deselect the seat
        seats[row][col] = 'A';
        selectedSeats.remove(row * 5 + col);
      }
    });
  }

  // Function to handle booking of selected seats
  void confirmBooking() {
    if (selectedSeats.isEmpty) {
      _showErrorDialog("Please select at least one seat to proceed with booking.");
    } else {
      // Navigate to BookingScreen and pass the number of selected seats
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingScreen(
            selectedSeatsCount: selectedSeats.length,
          ),
        ),
      );
    }
  }

  // Show confirmation or error dialog
  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Preview for ${widget.busName}'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Departure: ${widget.departure}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Destination: ${widget.destination}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Travel Date: ${widget.travelDate.toLocal()}'.split(' ')[0],
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            // Seating Arrangement
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 seats per row
                  crossAxisSpacing: 6.0, // Reduced Gaps between columns
                  mainAxisSpacing: 10.0, // Reduced Gaps between rows
                ),
                itemCount: 45, // 9 rows * 5 seats
                itemBuilder: (context, index) {
                  int row = index ~/ 5; // Row index
                  int col = index % 5; // Column index
                  String seatStatus = seats[row][col];

                  // Handle aisle and row-specific seat layouts
                  if (row < 8) {
                    if (col == 2) {
                      return SizedBox(width: 10); // Add aisle gap between columns
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      if (seatStatus != 'B') {
                        toggleSeatSelection(row, col); // Toggle selection
                      }
                    },
                    child: Container(
                      width: 30, // Smaller width for each seat
                      height: 30, // Smaller height for each seat
                      decoration: BoxDecoration(
                        color: seatStatus == 'A'
                            ? Colors.green
                            : seatStatus == 'S'
                                ? Colors.blue
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: seatStatus == 'A'
                              ? Colors.green
                              : seatStatus == 'S'
                                  ? Colors.blue
                                  : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'R${row + 1}C${col + 1}',
                          style: TextStyle(
                            color: seatStatus == 'A'
                                ? Colors.white
                                : seatStatus == 'S'
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Smaller text size
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Booking Button
            Center(
              child: ElevatedButton(
                onPressed: confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Select Seats',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
