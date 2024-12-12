import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bus_list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _selectedDate;

  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;
  late AnimationController _slideInController;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Fade-in Animation
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );

    // Slide-in Animation
    _slideInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _slideInAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideInController, curve: Curves.easeInOut));

    _fadeInController.forward();
    _slideInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(opacity: _fadeInAnimation, child: _buildWelcomeMessage(theme)),
            const SizedBox(height: 20),
            SlideTransition(position: _slideInAnimation, child: _buildSearchSection(context)),
            const SizedBox(height: 20),
            _buildPromoSection(),
            const SizedBox(height: 20),
            FadeTransition(opacity: _fadeInAnimation, child: _buildTopDestinations()),
            const SizedBox(height: 20),
            FadeTransition(opacity: _fadeInAnimation, child: _buildRecentSearches()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // Implement drawer or side menu functionality if needed
        },
      ),
      title: const Text('', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: theme.primaryColor,
      actions: [_buildLoginButton(context)],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildWelcomeMessage(ThemeData theme) {
    return Text(
      'Welcome to Bus Planner! 🚍\nFind your perfect journey with ease.',
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCustomTextField(controller: _departureController, label: 'From (City or Stop)', icon: Icons.location_on),
            const SizedBox(height: 12),
            _buildCustomTextField(controller: _destinationController, label: 'To (City or Stop)', icon: Icons.location_city),
            const SizedBox(height: 12),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildSearchButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: _onSearchPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      child: const Text('Search Buses', style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://media.istockphoto.com/id/1215274990/photo/high-wide-angle-view-of-charminar-in-the-night.jpg?s=612x612&w=0&k=20&c=byyIjqgbslf-L191n6SJu0s35fvNoVeWsxV5rIPK7Sk='),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Destinations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildDestinationCard('Mumbai', 'https://i.natgeofe.com/n/a3ab98d9-e181-4ab3-a888-742c65acaf26/gateway-of-india-mumbai-india_3x2.jpg'),
              const SizedBox(width: 12),
              _buildDestinationCard('Delhi', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0fPtWTXMcs6kMhanxp8s2HwJp7y3xKaXVGw&s'),
              const SizedBox(width: 12),
              _buildDestinationCard('Bangalore', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQJCcEXf7elSVdiY2bfeJ4AKi3sHVCeIVvaQ&s'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(String city, String imageUrl) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomLeft,
        child: Text(city, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildSearchHistoryItem('Mumbai to Pune', '12 Dec 2024'),
        _buildSearchHistoryItem('Delhi to Jaipur', '11 Dec 2024'),
      ],
    );
  }

  Widget _buildSearchHistoryItem(String route, String date) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(route),
      subtitle: Text(date),
      trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedDate == null
                ? 'Select Travel Date'
                : 'Travel Date: ${DateFormat('d MMM yyyy').format(_selectedDate!)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: const Text('Pick Date', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _onSearchPressed() {
    if (_departureController.text.isNotEmpty && _destinationController.text.isNotEmpty && _selectedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusListScreen(
            departure: _departureController.text,
            destination: _destinationController.text,
            date: _selectedDate!,
          ),
        ),
      );
    } else {
      _showErrorDialog(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Please fill out all fields to proceed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}
