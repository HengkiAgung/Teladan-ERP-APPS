import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../bloc/approval_detail/approval_detail_bloc.dart';
import '../../../../components/approval_action_component.dart';
import '../../../../components/detail_request_component.dart';

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

  _DetailAttendanceApprovalPageState({required this.id});

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<ApprovalDetailBloc, ApprovalDetailState>(
        builder: (context, state) {
          if (state is ApprovalDetailLoading) {
            return const Text("Loading...");
          } else if (state is ApprovalDetailLoadSuccess) {
            var shift = state.request.user!.userEmployment!.workingScheduleShift
                .workingShift;
            var request = state.request;

            List<List<String>> stringChildren = [];

            if (request.isNotEmpty) {
              stringChildren.addAll([
                ["Tanggal absensi", request.date],
                [
                  "Shift",
                  "${shift!.name}, ${shift.working_start} - ${shift.working_end}"
                ],
                ["Reason", request.notes],
              ]);

              if (request.check_in != "") {
                stringChildren.add(["Check In", request.check_in]);
              }

              if (request.check_out != "") {
                stringChildren.add(["Check Out", request.check_out]);
              }

              if (request.comment != "") {
                stringChildren.add(["Comment", request.comment]);
              }
            }

            return Column(
              children: [
                Expanded(
                  child: DetailRequestComponent(
                    user: request.user!,
                    status: request.status,
                    stringChildren: stringChildren,
                    file: request.file,
                    type: "attendance",
                  ),
                ),
                request.status == "Waiting"
                    ? ApprovalActionComponent(
                        type: "attendance",
                        id: request.id.toString(),
                        source: DetailAttendanceApprovalPage(
                          id: request.id.toString(),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          }

          return const Text("Failed to load request");
        },
      ),
    );
  }
}
