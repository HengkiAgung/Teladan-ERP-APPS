import 'package:teladan/page/account/account_page.dart';
import 'package:teladan/page/employee_page.dart';
import 'package:teladan/page/inbox/inbox_page.dart';
import 'package:teladan/repositories/user_repository.dart';
import 'package:teladan/utils/middleware.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Employee/User.dart';
import 'home_page.dart';
import 'request/request_page.dart';

class MainPage extends StatefulWidget {
  final int index;
  bool error;
  MainPage({required this.index, this.error = false, super.key});

  @override
  // ignore: no_logic_in_create_state
  State<MainPage> createState() => _MainPageState(bottomNavIndex: index, error: error);
}

class _MainPageState extends State<MainPage> {
  int bottomNavIndex = 0;
  bool error;
  late BuildContext context;

  _MainPageState({required this.error, required this.bottomNavIndex});

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

      Middleware().authenticated(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: error ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Image.asset(
                      'images/logo-comtel-nig.png', // Replace with your logo asset path
                      width: 100.0, // Adjust the width as needed
                      height: 100.0, // Adjust the height as needed
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Teladan by Comtelindo',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Connection failed please try again',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        User user = await UserRepository().getUser();
                        if (user.name != "") setState(() {
                          error = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20,),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ) : _listWidget[bottomNavIndex],
      bottomNavigationBar: error ? SizedBox() : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavBarTapped,
      ),
    );
  }
}