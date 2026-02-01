import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:qr_code/screens/create_tabs/create.dart';
import 'package:qr_code/screens/favourites.dart';
import 'package:qr_code/screens/history.dart';
import 'package:qr_code/screens/scan.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/buttons/toggle_theme_button.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  late PageController _pageController;
  // pages list
  final List<Widget> _pages = [Scan(), Create(), Favourites(), History()];
  final List<String> _pageTitle = ["", "Create QR", "Favourites", "History"];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTappedItem(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              _pageTitle[_selectedIndex],
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.fredoka().fontFamily,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settingRoute);
            },
            icon: HugeIcon(
              size: 22,
              strokeWidth: 2,
              icon: HugeIcons.strokeRoundedSettings01,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const ClampingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTappedItem,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedQrCode01,
              strokeWidth: 1.5,
              size: 24,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedQrCode,
              strokeWidth: 1.5,
              size: 24,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              strokeWidth: 1.5,
              size: 24,
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedTransactionHistory,
              strokeWidth: 1.5,
              size: 24,
            ),
            label: 'History',
          ),
        ],
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.outline,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
