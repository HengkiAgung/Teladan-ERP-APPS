import 'package:teladan/page/request/time_off/detail_time_off_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/Attendance/UserLeaveRequest.dart';
import '../../../repositories/request_repository.dart';
import 'form_time_off_request_page.dart';

class TimeOffRequestPage extends StatefulWidget {
  const TimeOffRequestPage({super.key});

  @override
  State<TimeOffRequestPage> createState() => _TimeOffRequestPageState();
}

class _TimeOffRequestPageState extends State<TimeOffRequestPage> {
  final List<UserLeaveRequest> _logTimeOffRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchTimeOff() async {
    var newLog =
        await RequestRepository().getAllUserTimeOffRequest(page: page.toString());
    setState(() {
      _logTimeOffRequest.addAll(newLog);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchTimeOff();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchTimeOff();
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
            itemCount: _logTimeOffRequest.length,
            itemBuilder: (BuildContext context, int index) {
              var leaveRequest = _logTimeOffRequest[index];
              Color colorStatus;

              if (leaveRequest.status == "Waiting") {
                colorStatus = Colors.amber;
              } else if (leaveRequest.status == "Approved") {
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
                        builder: (context) => DetailTimeOffRequestPage(id: leaveRequest.id),
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
                              "${leaveRequest.leaveRequestCategory!.name}",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 51, 51, 51),
                              ),
                            ),
                            leaveRequest.approvalLine!.name != "" 
                            ?
                            Text(
                              "Approved by: ${leaveRequest.approvalLine!.name}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            )
                            :
                            const SizedBox(),
                            Text(
                              "Status",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              leaveRequest.status,
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
                builder: (context) => FormTimeOffRequestPage(),
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
              'Ajukan Time Off',
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
