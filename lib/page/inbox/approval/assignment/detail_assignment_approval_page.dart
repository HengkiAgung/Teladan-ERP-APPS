// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:teladan/bloc/approval_assignment_detail/approval_assignment_detail_bloc.dart';
import 'package:teladan/bloc/approval_assignment_list/approval_assignment_list_bloc.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/config.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:teladan/utils/middleware.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAssignmentApprovalPage extends StatefulWidget {
  final int id;
  const DetailAssignmentApprovalPage({super.key, required this.id});

  @override
  State<DetailAssignmentApprovalPage> createState() =>
      DetailAssignmentApprovalPageState(id: id);
}

class DetailAssignmentApprovalPageState
    extends State<DetailAssignmentApprovalPage> {
  final int id;

  void function() {
    Middleware().authenticated(context);

    context
        .read<ApprovalAssignmentDetailBloc>()
        .add(GetRequestAssigmentDetail(id: id));
    context
        .read<ApprovalAssignmentListBloc>()
        .add(const GetApprovalAssigment());
  }

  DetailAssignmentApprovalPageState({required this.id});
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
                "Detail Assignment",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Spacer(),
          // GestureDetector(
          //   onTap: () async {
          //     final Uri url = Uri.parse('${Config.url}/operation/assignment/edit/$id');
          //     if (!await launchUrl(url)) {
          //       throw Exception('Could not launch $url');
          //     }
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.only(right: 15.0),
          //     child: Icon(Icons.edit),
          //   ),
          // ),
        ],
      ),
      body: BlocBuilder<ApprovalAssignmentDetailBloc,
          ApprovalAssignmentDetailState>(
        builder: (context, state) {
          if (state is ApprovalAssignmentDetailLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is ApprovalAssignmentDetailLoadSuccess) {
            Assignment assignment = state.assignment;
            Color colorStatus;

            if (assignment.status == "Waiting") {
              colorStatus = Colors.amber;
            } else if (assignment.status == "Approved") {
              colorStatus = Colors.green;
            } else {
              colorStatus = Colors.red.shade900;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 200,
                              child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(
                                    double.parse(assignment.latitude),
                                    double.parse(assignment.longitude),
                                  ),
                                  zoom: 14,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.comtelindo.app',
                                  ),
                                  assignment.latitude != ""
                                      ? MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                  double.parse(
                                                      assignment.latitude),
                                                  double.parse(
                                                      assignment.longitude)),
                                              width: 20,
                                              height: 20,
                                              builder: (context) => const Icon(
                                                  Icons.location_on_outlined),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lokasi",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      assignment.location,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tanggal Mulai",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      assignment.start_date,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tanggal Selesai",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      assignment.end_date,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                (MediaQuery.of(context).size.width / 2) - 60),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorStatus,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          assignment.status,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
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
                                "Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                assignment.name,
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
                        padding: const EdgeInsets.symmetric(
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
                                "Working Start",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                assignment.working_start,
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
                        padding: const EdgeInsets.symmetric(
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
                                "Working End",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                assignment.working_end,
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
                        padding: const EdgeInsets.symmetric(
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
                                "Purpose",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                assignment.purpose,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                assignment.status == "Waiting"
                    ? Container(
                  height: 150,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                ModalBottomSheetComponent().loadingIndicator(context, "Mengirim data...");

                                bool updated = await ApprovalRepository()
                                    .updateStatusRequestAssigment(status: "Rejected", id: id);

                                Navigator.pop(context);
                                if (updated) {
                                  function();
                                } else {
                                  ModalBottomSheetComponent().errorIndicator(
                                      context, "Gagal mengubah status request");
                                }
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
                            child: GestureDetector(
                              onTap: () async {
                                ModalBottomSheetComponent().loadingIndicator(
                                    context, "Mengirim data...");

                                bool updated = await ApprovalRepository()
                                    .updateStatusRequestAssigment(status: "Approved", id: id);

                                Navigator.pop(context);
                                if (updated) {
                                  function();
                                } else {
                                  ModalBottomSheetComponent().errorIndicator(
                                      context, "Gagal mengubah status request");
                                }
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: Text(
                                  "Approve",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                ModalBottomSheetComponent().loadingIndicator(
                                    context, "Mengirim data...");

                                bool updated = await ApprovalRepository()
                                    .updateStatusRequestAssigment(status: "Canceled", id: id);

                                Navigator.pop(context);
                                if (updated) {
                                  function();
                                } else {
                                  ModalBottomSheetComponent().errorIndicator(
                                      context, "Gagal mengubah status request");
                                }
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                )
                : const SizedBox(),
              ],
            );
          } else {
            return const Text("Failed to load detail assignment request");
          }
        },
      ),
    );
  }
}
