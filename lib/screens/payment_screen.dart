import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart' show QrImageView, QrVersions;
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final int selectedSeatsCount;

  const PaymentScreen({
    super.key,
    required this.selectedSeatsCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = selectedSeatsCount * 580;

    // Define your UPI ID here
    const String upiId = "deepan09112004@okicici";
    final String upiPaymentLink =
        "upi://pay?pa=$upiId&pn=Deepan&mc=0000&tid=0123456789&trl=00&am=$totalAmount&cu=INR&url=";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Seats Selected
                Text(
                  'You have selected $selectedSeatsCount ${selectedSeatsCount > 1 ? 'seats' : 'seat'}.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 15),

                // Total Amount Display
                Text(
                  'Total Amount: ₹$totalAmount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 30),

                // Payment Method Selection
                Text(
                  'Select Payment Method:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 10),

                // Choose payment method (Card and UPI)
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.blue),
                    title: Text('Credit/Debit Card'),
                  ),
                ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.phone_android, color: Colors.orange),
                    title: Text('UPI Payment'),
                  ),
                ),
                const SizedBox(height: 30),

                // "Pay using QR code" Option
                Text(
                  'Or Pay using QR Code:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 20),

                // QR Code Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Show QR code dialog
                      _showQRCodeDialog(context, upiPaymentLink);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Generate QR Code for Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Proceed to Payment Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _startPaymentProcess(context, totalAmount);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mock payment process
  void _startPaymentProcess(BuildContext context, int totalAmount) {
    Fluttertoast.showToast(
      msg: "Payment process started for ₹$totalAmount",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Future.delayed(Duration(seconds: 3), () {
      _showPaymentSuccessDialog(context);
    });
  }

  // Show success dialog
  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 40),
        content: Text(
          'Payment Successful!\nYour booking is confirmed.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Close payment screen
            },
            child: Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // Function to display QR Code
  void _showQRCodeDialog(BuildContext context, String upiPaymentLink) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Scan QR Code to Pay", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: upiPaymentLink,
                size: 180.0, // Adjust QR size
                version: QrVersions.auto,
              ),
              const SizedBox(height: 20),
              Text(
                'Scan this QR code with your UPI app to make the payment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(upiPaymentLink)) {
                    await launch(upiPaymentLink); // Launch UPI app with the payment link
                  } else {
                    Fluttertoast.showToast(msg: "Unable to open UPI app");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
                child: Text("Open UPI App", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('Close', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
