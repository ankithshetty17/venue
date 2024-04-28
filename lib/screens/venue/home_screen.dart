// home_venue.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/screens/venue/form_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeVenue extends StatefulWidget {
  const HomeVenue({Key? key});

  @override
  State<HomeVenue> createState() => _HomeVenueState();
}

class _HomeVenueState extends State<HomeVenue> {
  
  TextEditingController _searchController = TextEditingController();
  String _selectedPlace = '';
  String _selectedLocation = '';
  List<String> _suggestions = [];
  String _latitude = '';
  String _longitude = '';
    bool _isSearching = false;



  final TextEditingController _venuenameController = TextEditingController();
  final TextEditingController _venueaddressController = TextEditingController();
  int numberOfHalls = 0;
  String? selectedCity;
 
   @override
  void dispose() {
    _searchController.dispose();
    _venuenameController.dispose();
    _venueaddressController.dispose();
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
   @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: paddingleft,
                top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'VENUE NAME',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.only(left: paddingleft),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _venuenameController,
                      decoration: InputDecoration(
                        hintText: "Enter Venue Name",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 202, 200, 200),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(left: paddingleft),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _venueaddressController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Address Here",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(left: paddingleft),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Location Here",
                              hintStyle: TextStyle(color: Colors.grey),
                              // suffixIcon: IconButton(
                              //   icon: Icon(Icons.search),
                              //   onPressed: () {
                              //     _searchLocation(_searchController.text);
                              //   },
                              // ),
                            ),
                            onChanged: (value) {
                              _getSuggestions(value);
                            },
                          ),
                        ),
                      ),
                      _suggestions.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: paddingleft,
                                top: 6,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _suggestions
                                    .map((suggestion) => GestureDetector(
                                          onTap: () {
                                            _searchController.text =
                                                suggestion;
                                            _searchLocation(suggestion);
                                          },
                                          child: Text(
                                            suggestion,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                              
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
               
                SizedBox(height: 15),
                Text(
                  'ADD NUMBER OF HALLS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Numbers..",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 202, 200, 200),
                        ),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          numberOfHalls = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CustomButtonSmall(
                      onPressed: () {
                        _saveLocation(_selectedPlace, _latitude, _longitude);
                        if (numberOfHalls > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormPage(numberOfHalls: numberOfHalls),
                            ),
                          );
                        } else {
                          // Handle case when no halls are entered
                        }
                      },
                      text: 'GO',
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
}