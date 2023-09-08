import 'package:teladan/models/Attendance/UserAttendanceRequest.dart';
import 'package:teladan/page/request/attendance/detail_attendance_request_page.dart';
import 'package:teladan/page/request/attendance/form_attendance_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../repositories/request_repository.dart';

class AttendanceRequestPage extends StatefulWidget {
  const AttendanceRequestPage({super.key});

  @override
  State<AttendanceRequestPage> createState() => _AttendanceRequestPageState();
}

class _AttendanceRequestPageState extends State<AttendanceRequestPage> {
  final List<UserAttendanceRequest> _logAttendanceRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchAttendance() async {
    var data =
        await RequestRepository().getAllUserAttendanceRequest(page: page.toString());
    setState(() {
      _logAttendanceRequest.addAll(data);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchAttendance();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) - 280,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _logAttendanceRequest.length,
            itemBuilder: (BuildContext context, int index) {
              var attendanceRequest = _logAttendanceRequest[index];
              Color colorStatus;

              if (attendanceRequest.status == "Waiting") {
                colorStatus = Colors.amber;
              } else if (attendanceRequest.status == "Approved") {
                colorStatus = Colors.green;
              } else {
                colorStatus = Colors.red.shade900;
              }

              return Container(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Color.fromARGB(160, 158, 158, 158),
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAttendanceRequestPage(id: attendanceRequest.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attendanceRequest.date,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 51, 51, 51),
                              ),
                            ),
                            attendanceRequest.check_in != "" ?
                            Text(
                              "Check In pada ${attendanceRequest.check_in}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ) : SizedBox(),
                            attendanceRequest.check_out != "" ?
                            Text(
                              "Check Out pada ${attendanceRequest.check_out}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ) : SizedBox(),
                            const SizedBox(),
                            Text(
                              "Status",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              attendanceRequest.status,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: colorStatus,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.more_vert),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
