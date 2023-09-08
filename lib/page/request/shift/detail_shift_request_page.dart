import 'package:teladan/models/Attendance/UserShiftRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/avatar_profile_component.dart';
import '../../../models/Employee/User.dart';
import '../../../repositories/request_repository.dart';
import '../../../repositories/user_repository.dart';

class DetailShiftRequestPage extends StatefulWidget {
  final int id;
  const DetailShiftRequestPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailShiftRequestPage> createState() =>
      DetailShiftRequestPageState(id: id);
}

class DetailShiftRequestPageState extends State<DetailShiftRequestPage> {
  final int id;

  DetailShiftRequestPageState({required this.id});
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
      body: FutureBuilder<UserShiftRequest>(
        future: RequestRepository().getDetailUserShiftRequest(id),
        builder:
            (BuildContext context, AsyncSnapshot<UserShiftRequest> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return Text(
              'Loading',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            UserShiftRequest request = snapshot.data!;

            Color colorStatus;

            if (request.status == "Waiting") {
              colorStatus = Colors.amber;
            } else if (request.status == "Approved") {
              colorStatus = Colors.green;
            } else {
              colorStatus = Colors.red.shade900;
            }

            return ListView(
              children: [
                FutureBuilder<User?>(
                  future: UserRepository().getUser(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the result, you can show a loading indicator.
                      // return const CircularProgressIndicator();
                      return const Text('Loading');
                    } else if (snapshot.hasError) {
                      // Handle the error case here.
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return AvatarProfileComponent(
                        user: snapshot.data!,
                      );
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width / 2) - 60),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorStatus,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    request.status,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Tanggal",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          request.date,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Shift",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${request.workingShift.name}, ${request.workingShift.working_start} - ${request.workingShift.working_end}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Alasan",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          request.notes,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                request.approvalLine!.email != ""
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Approved by",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    request.approvalLine!.name +
                                        ", " +
                                        request.approvalLine!.email,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color:
                                          const Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Catatan ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    request.comment != ""
                                        ? request.comment
                                        : "-",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color:
                                          const Color.fromARGB(255, 51, 51, 51),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            );
          }
        },
      ),
    );
  }
}
