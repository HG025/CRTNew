import 'package:crt/screens/createPost.dart';
import 'package:crt/screens/customDrawer.dart';
import 'package:crt/screens/maps.dart';
import 'package:crt/screens/pie_chart.dart';
import 'package:crt/screens/posts.dart';
import 'package:crt/screens/search.dart';
import 'package:flutter/material.dart';

class Customnavigations extends StatefulWidget {
  const Customnavigations({super.key});

  @override
  State<Customnavigations> createState() => _CustomnavigationsState();
}

class _CustomnavigationsState extends State<Customnavigations> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Posts(),
    const Maps(),
    const CrimeTypePieChart(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 1, 34, 3), // Background color
          selectedItemColor: Colors.white, // Color for selected item
          unselectedItemColor: Colors.grey, // Color for unselected items
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'lib/assets/CRT-headerlogo.png', // Make sure the path is correct
            width: 100,
            height: 100,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8.0), // Adjust margin as needed
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of the circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: const Color.fromARGB(255, 1, 34, 3),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Search())));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0), // Adjust margin as needed
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of the circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: const Color.fromARGB(255, 1, 34, 3),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Createpost()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0), // Adjust margin as needed
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of the circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                color: const Color.fromARGB(255, 1, 34, 3),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Customdrawer()),
                  );
                },
              ),
            ),
          ],
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: _pages[_selectedIndex], // Display content based on selected index
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.maps_ugc),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Pie Chart',
            ),
          ],
        ),
      ),
    );
  }
}
