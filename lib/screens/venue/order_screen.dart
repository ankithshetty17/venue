import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/profile_screen.dart';
import 'package:venue/screens/venue/explore_venue.dart';
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    if (_selectedIndex == 0) { // Profile icon index
      // Navigate to the profile page
      NavigationUtils.navigateToPage(context,VenueExplore());
    }
   
     else if (_selectedIndex == 3) { // Profile icon index
      // Navigate to the profile page
      NavigationUtils.navigateToPage(context,ProfileScreen());
    }
    else if (_selectedIndex == 1) { // Profile icon index
      // Navigate to the profile page
      NavigationUtils.navigateToPage(context,OverlayFilter());
    }
  });
}
 int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/package.png'),
                SizedBox(height: 10,),
              Text('No Orders Yet',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 7,),
               Text('You Can View Your Orders Here',
              style: TextStyle(fontSize: 14,color: Colors.grey),),
             
             
            //     SizedBox(height: 15,),
            //     GestureDetector(onTap: (){
            //       //  NavigationUtils.navigateToPage(context,AdditemDetails());
            //     },
            //  child: Container(
            //     height: 50,
            //     width: 150,
            //     decoration: BoxDecoration(
                 
            //       borderRadius: BorderRadius.circular(5),
            //     border: Border.all(
            //       color: Colors.black,
            //     )
            //     ),
            //     child: Center(
            //       child:Text('ADD ITEMS')
            //     ),
            //   ),
            //     ),
            ],

          ),
          ),
           bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color when selected
        unselectedItemColor: Colors.grey, // Color when not selected
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            
          ),
        ],
      ),
    );
  
  }
}