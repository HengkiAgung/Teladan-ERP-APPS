import 'package:teladan/models/Attendance/UserShiftRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../components/approval_action_component.dart';
import '../../../../components/detail_request_component.dart';
import '../../../../repositories/approval_repository.dart';

// ignore: must_be_immutable
class DetailShiftApprovalPage extends StatefulWidget {
  String id;
  DetailShiftApprovalPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailShiftApprovalPage> createState() =>
      // ignore: no_logic_in_create_state
      _DetailShiftApprovalPageState(id: id);
}

class _DetailShiftApprovalPageState extends State<DetailShiftApprovalPage> {
  String id;
  late List<UserShiftRequest> userShiftRequest = [];
  final TextEditingController commentController = TextEditingController();

  void fetchAttendance() async {
    var data = await ApprovalRepository().getDetailShiftApproval(id);
    setState(() {
      userShiftRequest.addAll([data]);
    });
  }

  @override
  void initState() {
    fetchAttendance();
    super.initState();
  }

  _DetailShiftApprovalPageState({required this.id});

  @override
  Widget build(BuildContext context) {
    var shift =
        userShiftRequest.isNotEmpty ? userShiftRequest[0].workingShift : null;
    List<List<String>> stringChildren = [];

    if (userShiftRequest.isNotEmpty) {
      stringChildren.addAll([
        ["Tanggal absensi", userShiftRequest[0].date],
        [
          "Shift",
          "${shift!.name}, ${shift.working_start} - ${shift.working_end}"
        ],
        ["Reason", userShiftRequest[0].notes],
      ]);

      if (userShiftRequest[0].comment != "") {
        stringChildren.add(["Comment", userShiftRequest[0].comment]);
      }
    }

    // var shift = userShiftRequest[0].user!.userEmployment!.workingScheduleShift.workingShift;
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
                "Detail Request Shift",
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
      bottomNavigationBar:
          userShiftRequest.isNotEmpty && userShiftRequest[0].status == "Waiting"
              ? 
              ApprovalActionComponent(
                type: "shift",
                id: userShiftRequest[0].id.toString(),
                source: DetailShiftApprovalPage(
                  id: userShiftRequest[0].id.toString(),
                ),
              )
              : null,
      body: userShiftRequest.isNotEmpty
          ? DetailRequestComponent(
              user: userShiftRequest[0].user!,
              status: userShiftRequest[0].status,
              displayAction: true,
              stringChildren: stringChildren,
            )
          : const SizedBox(),
    );
  }
}
