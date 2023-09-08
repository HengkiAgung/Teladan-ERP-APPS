import 'package:teladan/components/request_item_component.dart';
import 'package:teladan/page/inbox/approval/attendance/detail_attendance_approval_page.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/Attendance/UserAttendanceRequest.dart';

class AttendanceApprovalPage extends StatefulWidget {
  const AttendanceApprovalPage({super.key});

  @override
  State<AttendanceApprovalPage> createState() => _AttendanceApprovalPageState();
}

class _AttendanceApprovalPageState extends State<AttendanceApprovalPage> {
  List<UserAttendanceRequest> userAttendanceRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchAttendanceRequest() async {
    var data =
        await ApprovalRepository().getAttendanceApproval(page: page.toString());
    setState(() {
      userAttendanceRequest.addAll(data);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchAttendanceRequest();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchAttendanceRequest();
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
                "Request Attendance",
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: userAttendanceRequest.length,
        itemBuilder: (BuildContext context, int index) {
          var request = userAttendanceRequest[index];
          return RequestItemComponent(
            fun: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailAttendanceApprovalPage(
                          id: request.id.toString(),
                        )),
              );
            },
            title: request.user!.name,
            status: request.status,
            children: [
              Text(
                "Tanggal ${request.date}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              request.check_in != ""
                  ? Text(
                      "Check In pada ${request.check_in}",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    )
                  : SizedBox(),
              request.check_out != ""
                  ? Text(
                      "Check Out pada ${request.check_out}",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
