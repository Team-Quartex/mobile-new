import 'package:flutter/material.dart';
import '../AddPost/Addpost.dart';
import 'HomeContent/HomeContent.dart';
import '../Marketplace/Marketpage.dart';
import '../Profile/Profilepage.dart';
import '../Search/Searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  double? _deviceWidth, _deviceHeight;

  final List<Widget> _pages = [
    const HomeContent(),
    const SearchPage(),
    MarketPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: _bottomContainer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomContainer() {
    return SizedBox(
      width: _deviceWidth! * 0.9,
      height: _deviceHeight! * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: _deviceWidth! * 0.7,
            height: _deviceHeight! * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home_filled, 0),
                _navItem(Icons.search, 1),
                _navItem(Icons.store_mall_directory_sharp, 2),
                _navItem(Icons.person, 3),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPost()));
            },
            child: Container(
              width: _deviceHeight! * 0.07,
              height: _deviceHeight! * 0.07,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(35, 134, 136, 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          if (_currentIndex == index)
            Container(
              color: Colors.red,
              width: 3,
              height: 3,
            ),
        ],
      ),
    );
  }
}
