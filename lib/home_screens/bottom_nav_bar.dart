import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/home_screens/bookmark_screen.dart';
import 'package:quran_app/home_screens/browse_screen.dart';
import 'package:quran_app/home_screens/home_screen.dart';
import 'package:quran_app/home_screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late List screens;

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    screens = [
      const HomeScreen(),
      const BrowseScreen(),
      const BookmarkScreen(),
      const ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
            textStyle:
                const TextStyle(fontSize: 8, fontWeight: FontWeight.w500)),
        unselectedLabelStyle: GoogleFonts.poppins(
            textStyle:
                const TextStyle(fontSize: 8, fontWeight: FontWeight.w500)),
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedIconTheme: const IconThemeData(color: Colors.green),
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: SvgPicture.asset('assets/images/home2.svg'),
              activeIcon: SvgPicture.asset('assets/images/home.svg')),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/search.svg'),
            activeIcon: SvgPicture.asset('assets/images/search2.svg'),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/bookmark.svg'),
              activeIcon: SvgPicture.asset('assets/images/bookmark2.svg'),
              label: 'Bookmark'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/profile.svg'),
              activeIcon: SvgPicture.asset('assets/images/profile2.svg'),
              label: 'Profile')
        ],
      ),
    );
  }
}
