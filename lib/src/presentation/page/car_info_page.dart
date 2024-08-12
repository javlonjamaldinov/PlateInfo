import 'package:car_number/src/presentation/text/my_text.dart';
import 'package:car_number/src/presentation/text/my_text_styles.dart';
import 'package:car_number/src/usecase/fetch_car_info.dart';
import 'package:flutter/material.dart';

class CarInfoPage extends StatefulWidget {
  final FetchCarInfo fetchCarInfo;

  const CarInfoPage({super.key, required this.fetchCarInfo});

  @override
  _CarInfoPageState createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _driverInfo = '';
  String _errorText = '';
  bool _isSearching = false;

  // Method to fetch driver information based on car number
  Future<void> _fetchDriverInfo(String carNumber) async {
    setState(() {
      _isSearching = true; // Set searching state to true to show loading indicator
    });

    final isValidNumber =
        RegExp(r'^[A-Z]{2}\d{4}[A-Z]{2}$').hasMatch(carNumber.toUpperCase());

    if (!isValidNumber) {
      setState(() {
        _errorText = AppText.errorText; // Set error text if the car number format is invalid
        _driverInfo = '';
        _isSearching = false; // Reset searching state
      });
      return;
    }

    final cars = await widget.fetchCarInfo(carNumber);

    setState(() {
      if (cars.isNotEmpty) {
        // Format driver information if car data is found
        _driverInfo = cars
            .map((car) => 'Driver: ${car['driverName']}\n'
                'Car: ${car['carNumber']}\n'
                'Registration Date: ${car['registrationDate']}\n'
                'Registration Place: ${car['registrationPlace']}')
            .join('\n\n');
        _errorText = '';
      } else {
        _driverInfo = AppText.infoText; // Set text if no car information is found
        _errorText = '';
      }
      _isSearching = false; // Reset searching state
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
         AppText.driverinformation, // Set title text for the app bar
          style: MyTextStyles.driverinformation, // Use custom text style for the title
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppText.carnumber, // Placeholder text in the input field
                      hintStyle: TextStyle(color: Colors.teal.shade100),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.teal.shade600,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _errorText.isNotEmpty ? _errorText : null, // Show error text if any
                    ),
                    onSubmitted: (value) {
                      _fetchDriverInfo(value); // Fetch driver info when input is submitted
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      _fetchDriverInfo(_controller.text); // Fetch driver info when button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade800,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: _isSearching
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppText.search, // Button text
                            style: MyTextStyles.search, // Use custom text style for the button
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (_driverInfo.isNotEmpty)
              FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(
                  AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 500),
                  )..forward(),
                ),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, size: 40, color: Colors.teal),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Text(
                          _driverInfo,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
