import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../components/approval_action_component.dart';
import '../../../../models/Attendance/UserAttendanceRequest.dart';
import '../../../../components/detail_request_component.dart';
import '../../../../repositories/approval_repository.dart';

// ignore: must_be_immutable
class DetailAttendanceApprovalPage extends StatefulWidget {
  String id;
  DetailAttendanceApprovalPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailAttendanceApprovalPage> createState() =>
      // ignore: no_logic_in_create_state
      _DetailAttendanceApprovalPageState(id: id);
}

class _DetailAttendanceApprovalPageState
    extends State<DetailAttendanceApprovalPage> {
  String id;
  late List<UserAttendanceRequest> userAttendanceRequest = [];

  void fetchAttendance() async {
    var data = await ApprovalRepository().getDetailAttendanceApproval(id);
    setState(() {
      userAttendanceRequest.addAll([data]);
    });
  }

  @override
  void initState() {
    fetchAttendance();
    super.initState();
  }

  _DetailAttendanceApprovalPageState({required this.id});

  @override
  Widget build(BuildContext context) {
    List<List<String>> stringChildren = [];
    var shift = userAttendanceRequest.isNotEmpty
        ? userAttendanceRequest[0]
            .user!
            .userEmployment!
            .workingScheduleShift
            .workingShift
        : null;

    if (userAttendanceRequest.isNotEmpty) {
      stringChildren.addAll([
        ["Tanggal absensi", userAttendanceRequest[0].date],
        [
          "Shift",
          "${shift!.name}, ${shift.working_start} - ${shift.working_end}"
        ],
        ["Reason", userAttendanceRequest[0].notes],
      ]);
      
      if (userAttendanceRequest[0].check_in != "") {
        stringChildren.add(["Check In", userAttendanceRequest[0].check_in]);
      }

      if (userAttendanceRequest[0].check_out != "") {
        stringChildren.add(["Check Out", userAttendanceRequest[0].check_out]);
      }

      if (userAttendanceRequest[0].comment != "") {
        stringChildren.add(["Comment", userAttendanceRequest[0].comment]);
      }

    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                "Detail Request Attendance",
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
          Expanded(
            child: userAttendanceRequest.isNotEmpty
                ? DetailRequestComponent(
                    user: userAttendanceRequest[0].user!,
                    status: userAttendanceRequest[0].status,
                    displayAction: true,
                    stringChildren: stringChildren,
                    file: userAttendanceRequest[0].file,
                    type: "attendance",
                  )
                : const SizedBox(),
          ),
          userAttendanceRequest.isNotEmpty &&
              userAttendanceRequest[0].status == "Waiting"
          ? ApprovalActionComponent(
              type: "attendance",
              id: userAttendanceRequest[0].id.toString(),
              source: DetailAttendanceApprovalPage(
                id: userAttendanceRequest[0].id.toString(),
              ),
            )
          : const SizedBox(),
        ],
      ),
    );
  }
}
