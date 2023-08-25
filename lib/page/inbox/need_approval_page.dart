import 'package:comtelindo_erp/page/inbox/approval/attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeedApprovalPage extends StatelessWidget {
  const NeedApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) - 190,
      child: ListView(
        children: [
          // // Reimbursement
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
          //         const Icon(Icons.file_copy_outlined),
          //         const SizedBox(
          //           width: 12,
          //         ),
          //         Text(
          //           "Reimbursement",
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
        
          // Cuti
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PersonalPage(),
              //   ),
              // );
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
                    "Time Of",
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendancePage(),
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
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PersonalPage(),
              //   ),
              // );
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
                  const Icon(Icons.access_time),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Lembur",
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
        
          // Perubahan Shif
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PersonalPage(),
              //   ),
              // );
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
