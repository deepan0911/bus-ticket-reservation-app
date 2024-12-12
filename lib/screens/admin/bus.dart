class Bus {
  String name;
  String busNumber;
  int availableSeats;
  String departureCity;
  String arrivalCity;
  DateTime? departureTime;

  Bus({
    required this.name,
    required this.busNumber,
    required this.availableSeats,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
  });

  // Method to convert Bus object to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'busNumber': busNumber,
      'availableSeats': availableSeats,
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureTime': departureTime,
    };
  }
}
