import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:venue/components/configip.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/logout.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/vendor/vendor_register.dart';
import 'package:venue/screens/reset_password.dart';
import 'package:venue/screens/venue/explore_venue.dart';
import 'package:venue/screens/venue/venue_register.dart';
import 'package:venue/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io'; 
import 'package:venue/components/token_manager.dart';
class VenueLoginScreen extends StatefulWidget { 
  //const LoginScreen({super.key});
   final String? responseBody; //  optional

  const VenueLoginScreen({Key? key, this.responseBody}) : super(key: key);
 
  @override
  State<VenueLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VenueLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TokenManager _tokenManager = TokenManager();
  String ipAddress = Configip.ip;
  bool _obscureText = true;
  String? _passwordValidationError;
  bool _rememberMe = false;
  String? _emailValidationError;
  String? _validateEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() {
        // Show Snackbar if the name is empty
        //  showSnackbarError('Enter a valid email address');
        // Set the error message for the TextField
        _emailValidationError = 'Enter a Valid Email Address';
      });
      //  showSnackbarError( 'Enter a valid email address'); // Return the error message
    } else {
      // Clear any previous validation error
      setState(() {
        _emailValidationError = null;
      });
    }
    return null; // No error
  }
 String? _validatePassword(String value) {
  if (value.length < 10) {
    setState(() {
      _passwordValidationError = 'Password Should Atleast Contain 10 Characters';
    });
    return 'Password Should Atleast Contain 10 Characters';
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    setState(() {
      _passwordValidationError = 'Password Should Contain Atleast One Uppercase Letter';
    });
    return 'Password Should Contain Atleast One Uppercase Letter';
  } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    setState(() {
      _passwordValidationError = 'Password Should Contain Atleast One Special Character';
    });
    return 'Password Should Contain Atleast One Special Character';
  } else {
    setState(() {
      _passwordValidationError = null;
    });
    return null;
  }
}


Future<void> vendorLogin() async {
    // Extract email
    // and password from text controllers
    print("called");
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Create JSON data to send in the request body
    Map<String, String> userData = {
      'email': email,
      'password': password,
    };

    // Encode the data as JSON
    String jsonData = jsonEncode(userData);
    print('jsonData ${jsonData}');

    try {
      // Make the HTTP POST request to your backend
       var httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    var request = await httpClient.postUrl(
      //Uri.parse('https://34.125.168.131:8000/login'),
       Uri.parse('http://192.168.43.187:443/venue/login'),
    );
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonData);
    var response = await request.close().timeout(Duration(seconds: 60));
      // Check the response status code
      var responseData = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // Login successful, handle the response data
        
      Map<String, dynamic> responseMap = jsonDecode(responseData);
      String token = responseMap['token']; // Extract token from response
      // Perform actions based on successful login
      // print(responseMap['userType']);
      // String fullname = responseMap['fullname']; // Extract fullname from response
       // Print fullname
     // print('Fullname: $fullname');

      await _tokenManager.saveToken(token);
      print('Login successful, Token: $token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OverlayFilter()),
        );
      } else {
        // Login failed, handle the error
        print('Login failed, Status Code: ${responseData}');
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error occurred during login: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.27,
                        left: paddingleft),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
                      padding: EdgeInsets.only(left: paddingleft),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail_rounded,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "abc@email.com",
                                // errorText: _emailValidationError,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateEmail(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _emailValidationError != null
                        ? Text(
                            _emailValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
                      padding: EdgeInsets.only(left: paddingleft),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Your Password",
                                border: InputBorder.none,
                              ),
                               obscureText: _obscureText,
                                onChanged: (value) {
                                // Call the validation method when the text changes
                                _validatePassword(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _passwordValidationError != null
                        ? Text(
                            _passwordValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value;
                            });
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            NavigationUtils.navigateToPage(
                              context,
                              ResetPassword(),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            _validateEmail(_emailController.text);
                            // Check if there's any validation error
                            if (_emailValidationError == null) {
                              // If no validation error, proceed with signing in
                               vendorLogin();
                              // NavigationUtils.navigateToPage(
                              //     context, WelcomeScreen());
                            }
                            //  NavigationUtils.navigateToPage(
                            //   context,
                            // VenueExplore(),
                            // );
                          },
                          text: 'SIGN IN',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'OR',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 10, // Set the elevation value here
                            shadowColor: Color.fromRGBO(116, 117, 117, 1)
                                .withOpacity(0.2),
                            minimumSize: Size(
                              271,
                              58,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/facebook_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text(
                            'Login with Facebook',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 10, // Set the elevation value here
                            shadowColor: Color.fromRGBO(116, 117, 117, 1)
                                .withOpacity(0.2),
                            backgroundColor: Colors.white,
                            minimumSize: Size(
                              271,
                              58,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Dont have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '  Sign up',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    NavigationUtils.navigateToPage(
                                      context,
                                     SignupVenue(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.06,
              child: Image.asset(
                'assets/images/Vectorbg1.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
