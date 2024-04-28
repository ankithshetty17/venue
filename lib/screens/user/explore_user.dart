import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:venue/screens/user/find_vendors.dart';
class UserExplore extends  StatefulWidget {
  const UserExplore({super.key});

  @override
  State<UserExplore> createState() => _UserExploreState();
}

class _UserExploreState extends State<UserExplore> {
   TextEditingController _searchController = TextEditingController();
   String _selectedPlace = '';
  String _selectedLocation = '';
  List<String> _suggestions = [];
  String _latitude = '';
  String _longitude = '';
    bool _isSearching = false;
 @override
  void dispose() {
    _searchController.dispose();
  
    super.dispose();
  }

void _saveLocation(String location, String latitude, String longitude) {
    print('Location saved: $location');
    print('Latitude saved: $latitude');
    print('Longitude saved: $longitude');
  }
  
Future<void> _getSuggestions(String query) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
        setState(() {
          _suggestions.clear();
          for (var prediction in data['predictions']) {
            _suggestions.add(prediction['description']);
          }
        });
      }
    } catch (e) {
      print('Error getting suggestions: $e');
    }
  }

void _searchAndSaveLocation() {
    if (!_isSearching) {
      setState(() {
        _isSearching = true;
      });
      _searchLocation(_searchController.text);
      _saveLocation(_selectedPlace, _latitude, _longitude);
    }
  }


  Future<void> _searchLocation(String query) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
        final placeId = data['predictions'][0]['place_id'];
        _getPlaceDetails(placeId);
      } else {
        setState(() {
          _selectedPlace = 'No results found';
        });
      }
    } catch (e) {
      print('Error searching location: $e');
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['result'] != null) {
        final formattedAddress = data['result']['formatted_address'];
        final latitude = data['result']['geometry']['location']['lat'];
        final longitude = data['result']['geometry']['location']['lng'];

        setState(() {
          _selectedPlace = formattedAddress;
          _selectedLocation = 'Latitude: $latitude, Longitude: $longitude';
          _latitude = latitude.toString();
          _longitude = longitude.toString();
        });
      } else {
        setState(() {
          _selectedPlace = 'No results found';
          _selectedLocation = '';
          _latitude = '';
          _longitude = '';
        });
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
  }




  bool isContainer3Clicked = false;
  bool isContainer2Clicked = false;
  bool isContainer4Clicked = false;
  bool isContainer1Clicked = false;

  Widget buildContainerListView() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        buildContainer(
          isContainer1Clicked,
          'Wedding',
          'assets/images/wedding.png',
          (bool newValue) {
            setState(() {
              isContainer1Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer2Clicked,
          'Birthday',
          'assets/images/birthday.png',
          (bool newValue) {
            setState(() {
              isContainer2Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer3Clicked,
          'Music',
          'assets/images/music.png',
          (bool newValue) {
            setState(() {
              isContainer3Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer4Clicked,
          'Corporate',
          'assets/images/wedding.png',
          (bool newValue) {
            setState(() {
              isContainer4Clicked = newValue;
            });
          },
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) {
        // Profile icon index
        // Navigate to the profile page
        NavigationUtils.navigateToPage(context, ProfileScreen());
      }
    });
  }

  Widget buildContainer(
    bool isClicked,
    String title,
    String imagePath,
    Function(bool) onTap,
  ) {
    return GestureDetector(
      onTap: () {
        onTap(!isClicked);
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: isClicked ? Color.fromRGBO(46, 138, 250, 1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isClicked ? Colors.white : Colors.grey.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isClicked ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  @override
   Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Location',
                style: TextStyle(
                  color: Color.fromRGBO(138, 189, 252, 1),
                  fontSize: 12,
                ),
              ),
              Text(
                'New York, USA',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.widgets_rounded), // Your left side icon
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications), // Another right side icon
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(55, 75, 248, 1),
                  Color.fromRGBO(46, 138, 250, 1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned.fill(
            top: screenSize.height *
                0.65, // Adjust this value to change the gradient's end position
            child: Container(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: paddingleft,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromRGBO(138, 189, 252, 1),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'Discover Amazing Event Places',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                      left: paddingleft,
                      top: MediaQuery.of(context).size.height * 0.03),
                  child: Container(
                    padding: EdgeInsets.only(left: paddingleft),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(46, 138, 250, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 230, 228, 228)
                            .withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search here...",
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              // errorText: _emailValidationError,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Call the validation method when the text changes
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: paddingleft),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: paddingleft),
                      child: GestureDetector(
                        onTap: () {
                          // NavigationUtils.navigateToPage(
                          //   context,
                          //   DemoScreen(),
                          // );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(138, 189, 252, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: Container(
                    // color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(right: 5, left: 5),

                        // color: Colors.black,
                        child: buildContainerListView(),
                      ),
                    ),
                  ),
                ),
             
               SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: Image.asset('assets/images/location.png'),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Add Your Location To Continue',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                // Show the location entry popup card
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(child:
                    SingleChildScrollView(
  child: 
  Center(child:
  AlertDialog(
    // title: Text('Enter Your Location'),
    content:  
    Container(
        // padding: EdgeInsets.only(left: paddingleft),
        child: Center(child:
        Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child:
                Container(
                  padding: EdgeInsets.only(left: paddingleft),
                  width: MediaQuery.of(context).size.width * 0.62,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Enter Location",
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _getSuggestions(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
            _suggestions.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      left: paddingleft,
                      top: 6,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _suggestions
                          .map((suggestion) => GestureDetector(
                                onTap: () {
                                  _searchController.text = suggestion;
                                  _searchLocation(suggestion);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:  Color.fromRGBO(46, 138, 250, 1),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          _saveLocation(_selectedPlace, _latitude, _longitude);
          setState(() {
            _searchController.text = '';
            _suggestions = [];
          });
          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>FindVendor()
                              
                            ),
                          );
          // Navigator.of(context).pop();
        },
         style: ElevatedButton.styleFrom(
          backgroundColor:  Color.fromRGBO(55, 75, 248, 1),
         ),
        child: Text('Submit'),
      ),
    ],
  ),
  ),
                    ),
);
                  },
                );
              },
              child: Center(child:
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: Text('Enter Location'),
                ),
              ),
            ),
            ),
                 

               


              ],
            ),
          ),
        
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   selectedItemColor: Colors.blue, // Color when selected
      //   unselectedItemColor: Colors.grey, // Color when not selected
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.explore),
      //       label: 'Explore',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart),
      //       label: 'Orders',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}