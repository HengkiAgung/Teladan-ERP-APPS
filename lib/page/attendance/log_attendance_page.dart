import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/Attendance.dart';
import '../../repositories/attendance_repository.dart';
import 'detail_attendance_page.dart';

class LogAttendance extends StatefulWidget {
  const LogAttendance({super.key});

  @override
  State<LogAttendance> createState() => _LogAttendanceState();
}

class _LogAttendanceState extends State<LogAttendance> {
  List<Attendance> _logAtendance = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchAttendance() async {
    var newLog = await AttendanceRepository().getHistoryAttendance(page: page.toString());
    setState(() {
      _logAtendance.addAll(newLog);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color.fromARGB(255, 226, 226, 226),
            height: 1,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Center(
              child: Text(
                "Log Attendance",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Spacer()
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   child: Row(
          //     children: [
          //       IconButton(
          //         onPressed: () async {
          //           final picked = await showDateRangePicker(
          //             context: context,
          //             lastDate: new DateTime(2024),
          //             firstDate: new DateTime(2019),
          //           );
          //           if (picked != null) {
          //             setState(() {
          //               // var startDate = picked.start;
          //               // var endDate = picked.end;
          //             });
          //           }
          //         },
          //         icon: const Icon(
          //           Icons.calendar_month_outlined,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _logAtendance.length,
              itemBuilder: (BuildContext context, int index) {
                var attendance = _logAtendance[index];
                var check_in =
                    attendance.check_in != "" ? attendance.check_in.split(' ')[1].substring(0, 5) : "-";
                var check_out =
                    attendance.check_out != "" ? attendance.check_out.split(' ')[1].substring(0, 5) : "-";

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
                          builder: (context) => DetailAttendance(date: attendance.date),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                attendance.date,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 50,
                                child: Text(
                                  check_in,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 50,
                                child: Text(
                                  check_out,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
