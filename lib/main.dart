import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Gateway',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentDetailsScreen(),
    );
  }
}

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Color.fromARGB(255, 235, 167, 6),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Card Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildCardNumberField(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildExpiryDateField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCVVField()),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Or Pay Using UPI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildUPIIcons(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('cardNumber', _cardNumberController.text);
                        prefs.setString('expiryDate', _expiryDateController.text);
                        prefs.setString('cvv', _cvvController.text);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 243, 241, 247),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Proceed to Confirm',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 9, 1)),
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

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      decoration: const InputDecoration(
        labelText: 'Card Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your card number';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
      decoration: const InputDecoration(
        labelText: 'Expiry Date',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your expiry date';
        }
        return null;
      },
    );
  }

  Widget _buildCVVField() {
    return TextFormField(
      controller: _cvvController,
      decoration: const InputDecoration(
        labelText: 'CVV',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your CVV';
        }
        return null;
      },
    );
  }

  Widget _buildUPIIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildUPIIcon('assets/google_pay.png', 'Google Pay'),
        _buildUPIIcon('assets/phonepe.png', 'PhonePe'),
        _buildUPIIcon('assets/paytm.png', 'Paytm'),
      ],
    );
  }

  Widget _buildUPIIcon(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Color.fromARGB(255, 231, 126, 6),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card,
              size: 100,
              color: Color.fromARGB(255, 228, 218, 244),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm Your Payment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
                'Please review your payment details\n'
                'before confirming.\nPay 100 INR for booking the slot',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String cardNumber = prefs.getString('cardNumber') ?? '11111111';
                String expiryDate = prefs.getString('expiryDate') ?? '11';
                String cvv = prefs.getString('111') ?? '';

                // Simulate a payment processing delay
                await Future.delayed(const Duration(seconds: 2));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cvv: cvv,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 224, 216, 238),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Confirm Payment',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 9, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  const SuccessScreen({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation for Tick Mark
            Lottie.asset(
              'assets/tick.json', // Path to the Lottie JSON file
              width: 150, // Adjust the size of the animation
              height: 150,
              fit: BoxFit.cover,
              repeat: false, // Play the animation only once
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your payment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // New Text Box with Bold Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50], // Light green background
                borderRadius: BorderRadius.circular(10), // Rounded corners
                border: Border.all(
                  color: Colors.green, // Green border
                  width: 2,
                ),
              ),
              child: const Text(
                'The user successfully booked the slot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.green, // Green text
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Payment Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text('Card Number: $cardNumber'),
                    Text('Expiry Date: $expiryDate'),
                    Text('CVV: $cvv'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 235, 233, 238),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 9, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}