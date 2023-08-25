import 'package:comtelindo_erp/page/request/shift_request_page.dart';
import 'package:comtelindo_erp/page/request/time_of_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'attendance_request_page.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int navIndex = 0;
  
  final List<Widget> _listWidget = [
    const AttendanceRequestPage(),
    const ShiftRequestPage(),
    const TimeOfRequestPage(),
  ];
  void _onNavBarTapped(int index) {
    setState(() {
      navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 12),
            margin: EdgeInsetsDirectional.only(top: 20),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "Riwayat Pengajuan",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(top: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(160, 158, 158, 158),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: (){
                    _onNavBarTapped(0);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Attendance",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: navIndex == 0 ?Colors.amber : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _onNavBarTapped(1);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Shift",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: navIndex == 1 ?Colors.amber : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _onNavBarTapped(2);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Time Of",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: navIndex == 2 ?Colors.amber : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _listWidget[navIndex],
        ],
      ),
    );
  }
}
