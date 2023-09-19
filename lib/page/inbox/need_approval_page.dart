import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/page/inbox/approval/attendance/attendance_approval_page.dart';
import 'package:teladan/page/inbox/approval/time_off/time_off_approval_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/approval_list/approval_list_bloc.dart';
import '../../models/Attendance/UserAttendanceRequest.dart';
import '../../models/Attendance/UserLeaveRequest.dart';
import '../../models/Attendance/UserShiftRequest.dart';
import 'approval/shift/shift_approval_page.dart';

class NeedApprovalPage extends StatelessWidget {
  const NeedApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) - 190,
      child: ListView(
        children: [
        
          // Cuti
          GestureDetector(
            onTap: () {
              context.read<ApprovalListBloc>().add(GetRequestList(key: "userTimeOffRequest", type: "time-off", model: UserLeaveRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => const TimeOffApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(160, 158, 158, 158),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Time Off",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_right_rounded),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),
        
          // Absensi
          GestureDetector(
            onTap: () {
              context.read<ApprovalListBloc>().add( GetRequestList(key: "userAttendanceRequest", type: "attendance", model: UserAttendanceRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(160, 158, 158, 158),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.location_history_rounded),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Absensi",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_right_rounded),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),
        
          // Lembur
          // GestureDetector(
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => PersonalPage(),
          //     //   ),
          //     // );
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 20),
          //     decoration: const BoxDecoration(
          //       color: Color.fromARGB(255, 255, 255, 255),
          //       border: Border(
          //         bottom: BorderSide(
          //           width: 0.5,
          //           color: Color.fromARGB(160, 158, 158, 158),
          //         ),
          //       ),
          //     ),
          //     child: Row(
          //       children: [
          //         const SizedBox(
          //           width: 12,
          //         ),
          //         const Icon(Icons.access_time),
          //         const SizedBox(
          //           width: 12,
          //         ),
          //         Text(
          //           "Lembur",
          //           style: GoogleFonts.poppins(
          //             fontSize: 13,
          //             color: const Color.fromARGB(255, 51, 51, 51),
          //           ),
          //         ),
          //         const Spacer(),
          //         const Icon(Icons.keyboard_arrow_right_rounded),
          //         const SizedBox(
          //           width: 12,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        
          // Perubahan Shift
          GestureDetector(
            onTap: () {
              context.read<ApprovalListBloc>().add(GetRequestList(key: "userShiftRequest", type: "shift", model: UserShiftRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShiftApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(160, 158, 158, 158),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.loop_rounded),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Perubahan Shift",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_right_rounded),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
