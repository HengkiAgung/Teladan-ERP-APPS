import 'package:comtelindo_erp/page/account/account_page.dart';
import 'package:comtelindo_erp/page/employee_page.dart';
import 'package:comtelindo_erp/page/inbox/inbox_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'request/request_page.dart';

class MainPage extends StatefulWidget {
  final int index;
  const MainPage({required this.index, super.key});

  @override
  State<MainPage> createState() => _MainPageState(bottomNavIndex: index);
}

class _MainPageState extends State<MainPage> {
  int bottomNavIndex = 0;

  _MainPageState({required this.bottomNavIndex});

  final List<Widget> _listWidget = [
    const HomePage(),
    const EmployeePage(),
    const RequestPage(),
    const InboxPage(),
    const AccountPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Karyawan',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.insert_drive_file),
      label: 'Pengajuan',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.move_to_inbox),
      label: 'Inbox',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Account',
    ),
  ];

  void _onBottomNavBarTapped(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavBarTapped,
      ),
    );
  }
}
