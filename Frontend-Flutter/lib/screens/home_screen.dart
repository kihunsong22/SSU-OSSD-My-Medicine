import 'package:flutter/material.dart';
import 'package:medicineapp/screens/list_presc_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreen extends StatelessWidget {
  final int uid;

  HomeScreen({
    super.key,
    // super.key,
    required this.uid,
  });

  // PersistentTabController _controller;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(uid),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}

List<Widget> _buildScreens(int uid) {
  return [
    ListPrescScreen(
      uid: uid,
    ), // Home
    ListPrescScreen(
      uid: uid,
    ), // Add
    ListPrescScreen(
      uid: uid,
    ), // Search
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.deepPurple[200]!,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.add),
      title: ("Add"),
      activeColorPrimary: Colors.deepPurple[200]!,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.grey,
      inactiveColorSecondary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: ("Search"),
      activeColorPrimary: Colors.deepPurple[200]!,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
