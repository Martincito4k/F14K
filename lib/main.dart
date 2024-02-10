// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:f14k/screens/home_page.dart';
import 'package:f14k/screens/drivers_page.dart';
import 'package:f14k/screens/realtime_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DriversPage(),
    RealtimePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(image: NetworkImage('https://images.fineartamerica.com/images/artworkimages/medium/3/racing-flag-icon-race-checker-chequred-checkered-flag-tom-hill-transparent.png'),width: 50, height: 50,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
             icon: Image(image: NetworkImage('https://images.vexels.com/media/users/3/156148/isolated/preview/98964d56995cde72b0ba42bf4644457b-helmet-icon-helmet.png'),width: 50, height: 50,),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Image(image: NetworkImage('https://www.clipartmax.com/png/full/241-2410437_open-cartoon-timer-clock.png'),width: 50, height: 50,),
            label: 'Intervals',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
      ),
    );
  }
}
