import 'package:comtelindo_erp/models/Attendance/UserAttendanceRequest.dart';
import 'package:comtelindo_erp/page/request/form/form_attendance_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../repositories/request_repository.dart';

class AttendanceRequestPage extends StatefulWidget {
  const AttendanceRequestPage({super.key});

  @override
  State<AttendanceRequestPage> createState() => _AttendanceRequestPageState();
}

class _AttendanceRequestPageState extends State<AttendanceRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) - 280,
          child: FutureBuilder<List<UserAttendanceRequest>>(
            future: RequestRepository().getAllUserAttendanceRequest(),
            builder: (BuildContext context, AsyncSnapshot<List<UserAttendanceRequest>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the result, you can show a loading indicator.
                // return const CircularProgressIndicator();
                return const Text('Loading');
              } else if (snapshot.hasError) {
                // Handle the error case here.
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var userAttendance = snapshot.data![index];

                    return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PersonalPage(),
                      //   ),
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromARGB(160, 158, 158, 158),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userAttendance.date,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                              Text(
                                "Check In pada ${userAttendance.check_in}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Check Out pada ${userAttendance.check_out}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                userAttendance.status,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.more_vert),
                          const SizedBox(width: 12,)
                        ],
                      ),
                    ),
                  );
                  },
                );
              }
            })
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormAttendanceRequestPage(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Ajukan Attendance',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
