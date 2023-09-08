import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../components/approval_action_component.dart';
import '../../../../components/detail_request_component.dart';
import '../../../../models/Attendance/UserLeaveRequest.dart';
import '../../../../repositories/approval_repository.dart';

// ignore: must_be_immutable
class DetailTimeOffApprovalPage extends StatefulWidget {
  String id;
  DetailTimeOffApprovalPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailTimeOffApprovalPage> createState() =>
      // ignore: no_logic_in_create_state
      _DetailTimeOffApprovalPageState(id: id);
}

class _DetailTimeOffApprovalPageState extends State<DetailTimeOffApprovalPage> {
  String id;
  late List<UserLeaveRequest> userTimeOffRequest = [];
  final TextEditingController commentController = TextEditingController();

  void fetch() async {
    var data = await ApprovalRepository().getDetailTimeOffApproval(id);
    setState(() {
      userTimeOffRequest.addAll([data]);
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  _DetailTimeOffApprovalPageState({required this.id});

  @override
  Widget build(BuildContext context) {
    List<List<String>> stringChildren = [];

    if (userTimeOffRequest.isNotEmpty) {
      stringChildren.addAll([
        ["Tanggal absensi", userTimeOffRequest[0].start_date],
        ["Reason", userTimeOffRequest[0].notes],
      ]);

      if (userTimeOffRequest[0].comment != "") {
        stringChildren.add(["Comment", userTimeOffRequest[0].comment]);
      }
    }

    print("objectBuild");
    // var shift = userTimeOffRequest[0].user!.userEmployment!.workingScheduleTimeOff.workingTimeOff;
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
                "Detail Request Time Off",
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
      bottomNavigationBar: userTimeOffRequest.isNotEmpty &&
              userTimeOffRequest[0].status == "Waiting"
          ? ApprovalActionComponent(
              type: "time-off",
              id: userTimeOffRequest[0].id.toString(),
              source: DetailTimeOffApprovalPage(
                id: userTimeOffRequest[0].id.toString(),
              ),
            )
          : null,
      body: userTimeOffRequest.isNotEmpty
          ? DetailRequestComponent(
              user: userTimeOffRequest[0].user!,
              status: userTimeOffRequest[0].status,
              displayAction: true,
              stringChildren: stringChildren,
              file: userTimeOffRequest[0].file,
              type: "timeoff",
            )
          : const SizedBox(),
    );
  }
}
