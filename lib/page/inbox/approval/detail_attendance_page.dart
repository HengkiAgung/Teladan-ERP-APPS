import 'package:comtelindo_erp/models/Attendance/UserAttendanceRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DetailAttendancePage extends StatefulWidget {
  UserAttendanceRequest userAttendanceRequest; 
  DetailAttendancePage({super.key, required this.userAttendanceRequest});

  @override
  // ignore: no_logic_in_create_state
  State<DetailAttendancePage> createState() => _DetailAttendancePageState(userAttendanceRequest: userAttendanceRequest);
}

class _DetailAttendancePageState extends State<DetailAttendancePage> {
  UserAttendanceRequest userAttendanceRequest; 

  _DetailAttendancePageState({required this.userAttendanceRequest});

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
      bottomNavigationBar: Container(
          height: 70,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 212, 212, 212),
                blurRadius: 4,
                offset: Offset(-2, 2), // Shadow position
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
              
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      "Reject",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: InkWell(
                  onTap: () async {

                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Approve',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,),
              child: Row(
                children: [
                  userAttendanceRequest.user!.foto_file != "" ?
                    CircleAvatar(
                      radius: 25, // Image radius
                      backgroundImage: NetworkImage(userAttendanceRequest.user!.foto_file)
                    )
                    :
                    const CircleAvatar(
                      radius: 25, // Image radius
                      backgroundImage: AssetImage("images/profile_placeholder.jpg"),
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        userAttendanceRequest.user!.name,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 51, 51, 51),
                        ),
                      ),
                      Text(
                        userAttendanceRequest.date,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        userAttendanceRequest.check_in + userAttendanceRequest.check_in != "" ? " " : "" + userAttendanceRequest.check_in,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              userAttendanceRequest.user!.name + " ingin mengajukan absen untuk tanggal:",
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Tanggal",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                Text(
                  userAttendanceRequest.date,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Check-In",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                Text(
                  userAttendanceRequest.check_in,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Check-Out",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                Text(
                  userAttendanceRequest.check_out,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Reason",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                Text(
                  userAttendanceRequest.notes,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              "Attachment",
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}