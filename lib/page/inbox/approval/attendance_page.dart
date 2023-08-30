import 'package:comtelindo_erp/page/inbox/approval/detail_attendance_page.dart';
import 'package:comtelindo_erp/repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/Attendance/UserAttendanceRequest.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<UserAttendanceRequest>>(
              future: ApprovalRepository().getApprovalAttendance(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserAttendanceRequest>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the result, you can show a loading indicator.
                  // return const CircularProgressIndicator();
                  return const Text('Loading');
                } else if (snapshot.hasError) {
                  // Handle the error case here.
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var request = snapshot.data![index];
                      return Container(
                        padding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 5,
                          bottom: 5,
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
                                builder: (context) => DetailAttendancePage(userAttendanceRequest: request),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                request.user!.foto_file != "" ?
                                  CircleAvatar(
                                    radius: 25, // Image radius
                                    backgroundImage: NetworkImage(request.user!.foto_file)
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
                                      request.user!.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 51, 51, 51),
                                      ),
                                    ),
                                    Text(
                                      request.date,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      request.status,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 51, 51, 51),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 12,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
