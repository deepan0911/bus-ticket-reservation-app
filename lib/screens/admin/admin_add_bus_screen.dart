import 'package:flutter/material.dart';
import 'bus.dart';

class AdminAddBusScreen extends StatefulWidget {
  const AdminAddBusScreen({super.key});

  @override
  _AdminAddBusScreenState createState() => _AdminAddBusScreenState();
}

class _AdminAddBusScreenState extends State<AdminAddBusScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _arrivalCityController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();

  DateTime? _departureDate;
  TimeOfDay? _departureTime;

  // Function to open Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _departureDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != _departureDate) {
      setState(() {
        _departureDate = selectedDate;
        // Update the date controller to show the selected date
        _departureDateController.text =
            '${_departureDate!.toLocal()}'.split(' ')[0]; // Show date only in 'yyyy-mm-dd' format
      });
    }
  }

  // Function to open Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _departureTime ?? TimeOfDay.now(),
    );
    if (selectedTime != null && selectedTime != _departureTime) {
      setState(() {
        _departureTime = selectedTime;
        // Update the time controller to show the selected time
        _departureTimeController.text = _departureTime!.format(context);
      });
    }
  }

  void _addBus() {
    if (_formKey.currentState?.validate() ?? false) {
      // Combine the selected date and time into a single DateTime object
      DateTime? combinedDepartureTime;
      if (_departureDate != null && _departureTime != null) {
        combinedDepartureTime = DateTime(
          _departureDate!.year,
          _departureDate!.month,
          _departureDate!.day,
          _departureTime!.hour,
          _departureTime!.minute,
        );
      }

      final newBus = Bus(
        name: _busNameController.text,
        busNumber: _busNumberController.text,
        availableSeats: int.tryParse(_seatsController.text) ?? 0,
        departureCity: _departureCityController.text,
        arrivalCity: _arrivalCityController.text,
        departureTime: combinedDepartureTime,
      );

      // Here you would typically save the bus data to a database.
      // For now, we're just printing it to the console.
      print('New Bus Added: ${newBus.name}, ${newBus.busNumber}, Seats: ${newBus.availableSeats}, '
          'From: ${newBus.departureCity} to ${newBus.arrivalCity}, Departure: ${newBus.departureTime}');

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bus added successfully!')),
      );

      // Clear the form
      _busNameController.clear();
      _busNumberController.clear();
      _seatsController.clear();
      _departureCityController.clear();
      _arrivalCityController.clear();
      _departureDateController.clear();
      _departureTimeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Bus Name
              TextFormField(
                controller: _busNameController,
                decoration: const InputDecoration(labelText: 'Bus Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bus name';
                  }
                  return null;
                },
              ),
              // Bus Number
              TextFormField(
                controller: _busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bus number';
                  }
                  return null;
                },
              ),
              // Available Seats
              TextFormField(
                controller: _seatsController,
                decoration: const InputDecoration(labelText: 'Available Seats'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter available seats';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Departure City
              TextFormField(
                controller: _departureCityController,
                decoration: const InputDecoration(labelText: 'Departure City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a departure city';
                  }
                  return null;
                },
              ),
              // Arrival City
              TextFormField(
                controller: _arrivalCityController,
                decoration: const InputDecoration(labelText: 'Arrival City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an arrival city';
                  }
                  return null;
                },
              ),
              // Departure Date
              GestureDetector(
                onTap: () {
                  _selectDate(context); // Open the date picker
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _departureDateController,
                    decoration: const InputDecoration(
                      labelText: 'Departure Date',
                      hintText: 'Tap to select date',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Departure Time
              GestureDetector(
                onTap: () {
                  _selectTime(context); // Open the time picker
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _departureTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Departure Time',
                      hintText: 'Tap to select time',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBus,
                child: const Text('Add Bus'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
