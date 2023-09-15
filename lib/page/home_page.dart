import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/attendance_log/attendance_log_bloc.dart';
import '../bloc/attendance_today/attendance_today_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../models/Attendance.dart';
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
    final attendanceLog = BlocProvider.of<AttendanceTodayBloc>(context);

    if (attendanceLog.state is! AttendanceTodayLoadSuccess) {
      context.read<AttendanceTodayBloc>().add(GetAttendanceToday());
    } 

    DateTime now = DateTime.now();
    var formatter = DateFormat('hh');
    int formattedHour = int.parse(formatter.format(now));

    String time;
    if (formattedHour >= 5 && formattedHour < 11) {
      time = 'Pagi';
    } else if (formattedHour >= 11 && formattedHour < 15) {
      time = 'Siang';
    } else if (formattedHour >= 15 && formattedHour < 18) {
      time = 'Sore';
    } else {
      time = 'Malam';
    }

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.amber.shade800),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat $time",
                          style: GoogleFonts.poppins(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoadSuccess) {
                              return Text(
                                state.user.name,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Jangan lupa absen hari ini!",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AttendanceTodayBloc, AttendanceTodayState>(
                    builder: (context, state) {
                      if (state is AttendanceTodayLoading) {
                        return const Text("Loading ...");
                      }
                      if (state is AttendanceTodayLoadSuccess) {
                        Attendance attendance = state.attendance;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          if (attendance.check_in == "") {
                                            bool attend =
                                                await AttendanceRepository()
                                                    .checkIn(context);

                                            if (attend) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        child: const Text(
                                          "Clock In",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            letterSpacing: 0.5,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      attendance.check_in != ""
                                          ? Text(
                                              attendance.check_in
                                                  .split(' ')[1]
                                                  .substring(
                                                      0,
                                                      attendance.check_in
                                                              .split(' ')[1]
                                                              .length -
                                                          3),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                fontSize: 16,
                                                color: Colors.amber,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          if (attendance.check_out == "") {
                                            bool attend =
                                                await AttendanceRepository()
                                                    .checkOut(context);

                                            if (attend) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        child: const Text(
                                          "Clock Out",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            letterSpacing: 0.5,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      attendance.check_out != ""
                                          ? Text(
                                              attendance.check_out
                                                  .split(' ')[1]
                                                  .substring(
                                                      0,
                                                      attendance.check_out
                                                              .split(' ')[1]
                                                              .length -
                                                          3),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                fontSize: 16,
                                                color: Colors.amber,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                bottom: 20,
                              ),
                              width: double.infinity,
                              child: Text(
                                attendance.date,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text("Failed to load daily absent");
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // daftar absensi
                  GestureDetector(
                    onTap: () {
                      final attendanceLog = BlocProvider.of<AttendanceLogBloc>(context);

                      if (attendanceLog.state is! AttendanceLogLoadSuccess) {
                        context.read<AttendanceLogBloc>().add(GetAttendanceLog());
                      } 

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
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
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
                  SizedBox(
                    height: 30,
                  ),
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
                            SizedBox(
                              height: 12,
                            ),
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
                                    snapshot.data!['lateCheckInCount']
                                        .toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
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
                                    snapshot.data!['earlyCheckOutCount']
                                        .toString(),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
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
                            SizedBox(
                              height: 12,
                            ),
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
