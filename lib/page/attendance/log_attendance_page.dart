import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/attendance_detail/attendance_detail_bloc.dart';
import '../../bloc/attendance_log/attendance_log_bloc.dart';
import '../../models/Attendance.dart';
import '../../utils/middleware.dart';
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

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<AttendanceLogBloc>().add(ScrollFetch(page: page));
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

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
      body: BlocBuilder<AttendanceLogBloc, AttendanceLogState>(
        builder: (context, state) {
          if (state is AttendanceLogLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is AttendanceLogLoadFailure) {
            return Text("Failed to load attendance log");
          } else if (state is AttendanceLogLoadSuccess) {
            _logAtendance = state.attendance;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    Middleware().authenticated(context);
                    
                    context.read<AttendanceLogBloc>().add(GetAttendanceLog());
                  },
                  child: ListView.builder(
                    controller: _logAtendance.length > 9 ? _scrollController : null,
                    itemCount: _logAtendance.length,
                    itemBuilder: (BuildContext context, int index) {
                      var attendance = _logAtendance[index];
                      var check_in = attendance.check_in != ""
                          ? attendance.check_in.split(' ')[1].substring(0, 5)
                          : "-";
                      var check_out = attendance.check_out != ""
                          ? attendance.check_out.split(' ')[1].substring(0, 5)
                          : "-";

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
                            Middleware().authenticated(context);
                            context.read<AttendanceDetailBloc>().add(
                                GetAttendanceDetail(date: attendance.date));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAttendance(),
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
              ),
              (state is AttendanceLogFetchNew)
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 40,
                        child: Text("Loading..."),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
