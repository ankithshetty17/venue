import 'dart:io';

import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/vendor/additem_details.dart';

class ListItems extends StatefulWidget {
  final List<String> itemNames;
  final List<String> itemDetails;
  final List<double> itemPrices;
  final List<String> itemImageUrls; // Add this

  const ListItems({
    Key? key,
    required this.itemNames,
    required this.itemDetails,
    required this.itemPrices,
    required this.itemImageUrls, // Update the constructor
  }) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Use the back arrow icon
            color: Colors.black,
          ),
          onPressed: () {
            NavigationUtils.navigateToPage(context, AdditemDetails());
          },
        ),
        title: Text(
          'List Items',
          style: TextStyle(fontSize: 19, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to AdditemDetails page to add a new item
              NavigationUtils.navigateToPage(context, AdditemDetails());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationUtils.navigateToPage(context, AdditemDetails());
                  },
                  child: Text(
                    'Add more',
                    style: TextStyle(
                        color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.itemNames.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Name: ${widget.itemNames[index]}',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Item Details: ${widget.itemDetails[index]}',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Price: ${widget.itemPrices[index]}',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(height: 10),
                widget.itemImageUrls[index].isNotEmpty
                    ? Image.file(
                        File(widget.itemImageUrls[index]),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
