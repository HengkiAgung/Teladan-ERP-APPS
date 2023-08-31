import 'package:comtelindo_erp/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/Attendance.dart';
import '../models/Employee/User.dart';
import '../repositories/attendance_repository.dart';

class TodayAttendanceComponent extends StatefulWidget {
  const TodayAttendanceComponent({super.key});

  @override
  State<TodayAttendanceComponent> createState() => _TodayAttendanceComponentState();
}

class _TodayAttendanceComponentState extends State<TodayAttendanceComponent> {
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('hh');
    int formattedHour = int.parse(formatter.format(now)) + 12;

    String time;
    if (formattedHour >= 5 && formattedHour < 11) {
      time =  'Pagi';
    } else if (formattedHour >= 11 && formattedHour < 15) {
      time =  'Siang';
    } else if (formattedHour >= 15 && formattedHour < 18) {
      time =  'Sore';
    } else {
      time =  'Malam';
    }

    formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<User?>(
            future: UserRepository().getUser(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the result, you can show a loading indicator.
                // return const CircularProgressIndicator();
                return const Text('Loading');
              } else if (snapshot.hasError) {
                // Handle the error case here.
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat $time",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        snapshot.data!.name,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
                );
              }
            },
          ),
          FutureBuilder<Attendance>(
            future: AttendanceRepository().getAttendanceDetail(formattedDate),
            builder:
                (BuildContext context, AsyncSnapshot<Attendance> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the result, you can show a loading indicator.
                // return const CircularProgressIndicator();
                return Text(
                  'Loading',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                // Handle the error case here.
                return Text('Error: ${snapshot.error}');
              } else {
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
                                  if (snapshot.data!.check_in == "") {
                                    bool attend = await AttendanceRepository()
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
                              snapshot.data!.check_in != ""
                                  ? Text(
                                      snapshot.data!.check_in.split(' ')[1].substring(0, snapshot.data!.check_in.split(' ')[1].length - 3),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                  if (snapshot.data!.check_in != "") {
                                    bool attend = await AttendanceRepository()
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
                              snapshot.data!.check_out != ""
                                  ? Text(
                                      snapshot.data!.check_out.split(' ')[1].substring(0, snapshot.data!.check_out.split(' ')[1].length - 3),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
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
                        snapshot.data!.date,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
