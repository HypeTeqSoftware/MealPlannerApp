import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Screens/Home_screen.dart';
import 'package:meal_tracker_app/Screens/ProfileScreen.dart';
import 'package:meal_tracker_app/Screens/Recipes_Screen.dart';
import 'package:meal_tracker_app/Screens/SettingScreen.dart';
class NavBarRoots extends StatefulWidget {
  const NavBarRoots({Key? key}) : super(key: key);

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    //Home Screen
    const HomeScreen(),
    //Messages Screen
    RecipeScreen(),
    //Schedule Screen
    const ProfileScreen(),
    //Setting Screen
    const SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 :  Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 52,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade300 : Colors.black,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
            unselectedItemColor: Colors.white60,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant,), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add_circled_solid,), label: "Add Meal"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_3_outlined), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings), label: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}
