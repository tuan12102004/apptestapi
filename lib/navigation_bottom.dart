import 'package:app_test/pages/pages_main/home_screen.dart';
import 'package:app_test/pages/pages_main/profile_screen.dart';
import 'package:app_test/pages/pages_main/recipe_screen.dart';
import 'package:app_test/pages/pages_main/search_screen.dart';
import 'package:flutter/material.dart';

class NavigationBottomNav extends StatefulWidget {
  const NavigationBottomNav({super.key});

  @override
  State<NavigationBottomNav> createState() => _NavigationBottomNavState();
}

class _NavigationBottomNavState extends State<NavigationBottomNav> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    SearchScreen(),
    SizedBox(),
    RecipeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: selectedIndex == 0 ? Colors.amber : Colors.grey),
              onPressed: () { setState(() => selectedIndex = 0); },
            ),
            IconButton(
              icon: Icon(Icons.search, color: selectedIndex == 1 ? Colors.amber : Colors.grey),
              onPressed: () { setState(() => selectedIndex = 1); },
            ),
            SizedBox(width: 48), // khoảng trống cho FAB
            IconButton(
              icon: Icon(Icons.bookmark_border, color: selectedIndex == 3 ? Colors.amber : Colors.grey),
              onPressed: () { setState(() => selectedIndex = 3); },
            ),
            IconButton(
              icon: Icon(Icons.person, color: selectedIndex == 4 ? Colors.amber : Colors.grey),
              onPressed: () { setState(() => selectedIndex = 4); },
            ),
          ],
        ),
      ) ,
      floatingActionButton:  GestureDetector(
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Color(0xffCEA700),
              Colors.amber,
            ],begin: Alignment.topCenter,
              end: Alignment.bottomCenter,),
           ),
          child: Icon(Icons.add, size: 70, color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
