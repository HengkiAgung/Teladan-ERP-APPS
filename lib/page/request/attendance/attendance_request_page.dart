import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/models/Attendance/UserAttendanceRequest.dart';
import 'package:teladan/page/request/attendance/detail_attendance_request_page.dart';
import 'package:teladan/page/request/attendance/form_attendance_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/request_attendance_list/request_attendance_list_bloc.dart';
import '../../../bloc/request_detail/request_detail_bloc.dart';
import '../../../utils/middleware.dart';

class AttendanceRequestPage extends StatefulWidget {
  const AttendanceRequestPage({super.key});

  @override
  State<AttendanceRequestPage> createState() => _AttendanceRequestPageState();
}

class _AttendanceRequestPageState extends State<AttendanceRequestPage> {
  List<UserAttendanceRequest> _userAttendanceRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          page = page + 1;
      context.read<RequestAttendanceListBloc>().add(
            ScrollFetch(
              page: page,
            ),
          );
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
    final attendanceRequest =
        BlocProvider.of<RequestAttendanceListBloc>(context);
    if (attendanceRequest.state is! RequestAttendanceListLoadSuccess) {
      // context.read<UserBloc>().add(CheckAuth());
      // final user = BlocProvider.of<UserBloc>(context);

      // if (user.state is UserUnauthenticated) Auth().logOut(context);
      Middleware().authenticated(context);

      context.read<RequestAttendanceListBloc>().add(const GetRequestList());
    }

    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) - 280,
          child: BlocBuilder<RequestAttendanceListBloc,
              RequestAttendanceListState>(
            builder: (context, state) {
              if (state is RequestAttendanceListLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 18.0, left: 18),
                  child: Text("loading..."),
                );
              } else if (state is RequestAttendanceListLoadFailure) {
                return const Text("Failed to load attendance log");
              } else if (state is RequestAttendanceListLoadSuccess) {
                _userAttendanceRequest =
                    state.request.cast<UserAttendanceRequest>();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<RequestAttendanceListBloc>()
                      .add(const GetRequestList());
                  setState(() {
                    page = 1;
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _userAttendanceRequest.length > 9 ? _scrollController : null ,
                        itemCount: _userAttendanceRequest.length,
                        itemBuilder: (BuildContext context, int index) {
                          var attendanceRequest = _userAttendanceRequest[index];
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
                                // context.read<UserBloc>().add(CheckAuth());
                                // final user = BlocProvider.of<UserBloc>(context);

                                // if (user.state is UserUnauthenticated) Auth().logOut(context);
                                Middleware().authenticated(context);

                                context.read<RequestDetailBloc>().add(
                                    GetRequestDetail(
                                        id: attendanceRequest.id.toString(),
                                        type: "attendance",
                                        model: UserAttendanceRequest()));
                    
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailAttendanceRequestPage(
                                        id: attendanceRequest.id),
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
                                            color:
                                                const Color.fromARGB(255, 51, 51, 51),
                                          ),
                                        ),
                                        attendanceRequest.check_in != ""
                                            ? Text(
                                                "Check In pada ${attendanceRequest.check_in}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : const SizedBox(),
                                        attendanceRequest.check_out != ""
                                            ? Text(
                                                "Check Out pada ${attendanceRequest.check_out}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : const SizedBox(),
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
                    (state is RequestAttendanceListFetchNew)
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 40,
                          child: Text("Loading..."),
                        ),
                      )
                    : const SizedBox(),
                  ],
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
