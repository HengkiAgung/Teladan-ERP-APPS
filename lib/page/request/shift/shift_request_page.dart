import 'package:comtelindo_erp/page/request/shift/form_shift_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/Attendance/UserShiftRequest.dart';
import '../../../repositories/request_repository.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  State<ShiftRequestPage> createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  List<UserShiftRequest> _logShiftRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  void fetchAttendance() async {
    var newLog =
        await RequestRepository().getAllUserShiftRequest(page: page.toString());
    setState(() {
      _logShiftRequest.addAll(newLog);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchAttendance();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height) - 280,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _logShiftRequest.length,
            itemBuilder: (BuildContext context, int index) {
              var shift = _logShiftRequest[index];
              Color colorStatus;

              if (shift.status == "Waiting") {
                colorStatus = Colors.amber;
              } else if (shift.status == "Approved") {
                colorStatus = Colors.green;
              } else {
                colorStatus = Colors.red.shade900;
              }

              return Container(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 20,
                  bottom: 20,
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shift.date,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 51, 51, 51),
                              ),
                            ),
                            Text(
                              "Approved by: ${shift.approvalLine!.name}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Status",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              shift.status,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: colorStatus,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.more_vert),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormShiftRequestPage(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Ajukan Perubahan Shift',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
