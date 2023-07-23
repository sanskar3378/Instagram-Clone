import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          const Text('feed'),
          const Text('search'),
          const Text('add'),
          const Text('notifications'),
          const Text('account'),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,

        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(_page == 0 ? Icons.home : Icons.home_outlined,
                  color: _page == 0 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(_page == 3 ? Icons.favorite : Icons.favorite_border,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: mobileBackgroundColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
