import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/models/Attendance/UserShiftRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../bloc/approval_detail/approval_detail_bloc.dart';
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

  _DetailShiftApprovalPageState({required this.id});

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<ApprovalDetailBloc, ApprovalDetailState>(
        builder: (context, state) {
          if (state is ApprovalDetailLoading) {
            return const Text("Loading...");
          } else if (state is ApprovalDetailLoadSuccess) {
            var request = state.request as UserShiftRequest;
            var shift = request.workingShift;
            List<List<String>> stringChildren = [];

            stringChildren.addAll([
              ["Tanggal absensi", request.date],
              [
                "Shift",
                "${shift!.name}, ${shift.working_start} - ${shift.working_end}"
              ],
              ["Reason", request.notes],
            ]);

            if (request.comment != "") {
              stringChildren.add(["Comment", request.comment]);
            }

            return Column(
                children: [
                  Expanded(
                    child: DetailRequestComponent(
                      user: request.user!,
                      status: request.status,
                      stringChildren: stringChildren,
                    ),
                  ),
                  request.status == "Waiting"
                      ? ApprovalActionComponent(
                          type: "shift",
                          id: request.id.toString(),
                          source: DetailShiftApprovalPage(
                            id: request.id.toString(),
                          ),
                        )
                      : const SizedBox(),
                ],
              );
          }
          return const Text("Failed to load request");
        },
      )
    );
  }
}
