import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/today_attendance_component.dart';
import '../repositories/attendance_repository.dart';
import 'attendance/log_attendance_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        child: ListView(
          children: [
            TodayAttendanceComponent(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuti
                  // Row(
                  //   children: [
                  //     Icon(Icons.calendar_month),
                  //     const SizedBox(
                  //       width: 12,
                  //     ),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Cuti',
                  //           style: GoogleFonts.poppins(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.bold,
                  //             color: Color.fromARGB(255, 51, 51, 51),
                  //           ),
                  //         ),
                  //         Text(
                  //           'Ajukan atau liat riwayat pengajuan cuti',
                  //           style: GoogleFonts.poppins(
                  //             fontSize: 11,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),

                  // daftar absensi
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogAttendance(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.library_books_outlined),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Absensi',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 51, 51, 51),
                              ),
                            ),
                            Text(
                              'Seluruh catatan absen kamu 📊',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        const Icon(Icons.keyboard_arrow_right_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // password
                  // Row(
                  //   children: [
                  //     Icon(Icons.lock_outline),
                  //     const SizedBox(
                  //       width: 12,
                  //     ),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Password',
                  //           style: GoogleFonts.poppins(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.bold,
                  //             color: Color.fromARGB(255, 51, 51, 51),
                  //           ),
                  //         ),
                  //         Text(
                  //           'Ubah kata sandi',
                  //           style: GoogleFonts.poppins(
                  //             fontSize: 11,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(0, 158, 158, 158).withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15,),
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    'Summaries',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  Text(
                    'Satu bulan terakhir',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30,),
                  FutureBuilder<dynamic>(
                    future: AttendanceRepository().getSummaries(null, null),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While waiting for the result, you can show a loading indicator.
                        // return const CircularProgressIndicator();
                        return const Text('Loading');
                      } else if (snapshot.hasError) {
                        // Handle the error case here.
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'On time',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!['onTimeCount'].toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Late check in',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!['lateCheckInCount'].toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Early check out',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!['earlyCheckOutCount'].toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Absent',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!['absent'].toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Time off',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!['timeOffCount'].toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
