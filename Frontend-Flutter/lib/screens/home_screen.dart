import 'package:flutter/material.dart';
import 'package:medicineapp/screens/login_screen.dart';
import 'package:medicineapp/screens/presc_list_screen.dart';
import 'package:medicineapp/screens/presc_upload_screen.dart';
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

  void setIndex(int index, BuildContext context) {
    _controller.index = index;
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: HomeScreen(
          uid: uid,
        ));
  }

  void pushExitScreen(BuildContext context) {
    // Navigaitor.of
    // Navigator.pop(context);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    //   // (Route<dynamic> route) => false,
    // );

    // PersistentNavBarNavigator.pushNewScreen(context, screen: LoginScreen()
    //     // HomeScreen(
    //     //   uid: uid,
    //     // )
    //     );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void pushUploadScreen(BuildContext context) {
    // PersistentNavBarNavigator.pushNewScreen(context,
    //     screen: DisplayPrescUploadScreen(uid: uid, func: pushExitScreen));
    // PersistentNavBarNavigator.pushNewScreen(context, screen: LoginScreen()
    //     // HomeScreen(
    //     //   uid: uid,
    //     // )
    //     );

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return PrescListScreen(
          uid: uid,
          func: pushExitScreen,
        );
      },
    ));

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //       builder: (context) => PrescListScreen(
    //             uid: uid,
    //             func: pushExitScreen,
    //           )),
    //   // (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(
        uid,
        pushExitScreen,
        pushUploadScreen,
      ),
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

List<Widget> _buildScreens(
    int uid, Function pushExitScreen, Function pushUploadScreen) {
  return [
    PrescListScreen(
      uid: uid,
      func: pushExitScreen,
    ), // Home
    PrescUploadScreen(
      uid: uid,
      func: pushUploadScreen,
    ), // Add
    PrescListScreen(
      uid: uid,
      func: pushExitScreen,
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
