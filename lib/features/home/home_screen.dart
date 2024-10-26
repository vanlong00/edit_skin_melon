import 'package:edit_skin_melon/features/home/pages/history_page.dart';
import 'package:edit_skin_melon/features/home/pages/home_page.dart';
import 'package:edit_skin_melon/widgets/app_keep_alive_widget.dart';
import 'package:flutter/material.dart';

import 'pages/community_page.dart';
import 'pages/workspace_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const CommunityPage(),
    const WorkspacePage(),
    const HistoryPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children:
              _pages.map((page) => AppKeepAliveWidget(child: page)).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => _onItemTapped(value),
        animationDuration: const Duration(milliseconds: 300),
        selectedIndex: _currentPage,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people_alt_rounded),
            icon: Icon(Icons.people_alt_outlined),
            label: 'Community',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.workspaces_filled),
            icon: Icon(Icons.workspaces_outlined),
            label: 'Workspace',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history_rounded),
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPage,
      //   onTap: _onItemTapped,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people_alt_rounded),
      //       label: 'Community',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.workspaces_filled),
      //       label: 'Workspace',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: 'History',
      //     ),
      //   ],
      // ),
    );
  }
}
