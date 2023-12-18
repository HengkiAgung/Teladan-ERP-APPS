// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:teladan/bloc/request_assigment_detail/request_assignment_detail_bloc.dart';
import 'package:teladan/bloc/request_assignment_list/request_assignment_list_bloc.dart';
import 'package:teladan/components/cancel_request_component.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/repositories/request_repository.dart';

import '../../../utils/middleware.dart';

class DetailAssignmentRequestPage extends StatefulWidget {
  final int id;
  const DetailAssignmentRequestPage({super.key, required this.id});

  @override
  State<DetailAssignmentRequestPage> createState() =>
      DetailAssignmentRequestPageState(id: id);
}

class DetailAssignmentRequestPageState
    extends State<DetailAssignmentRequestPage> {
  final int id;

  void onCancle() {
    Middleware().authenticated(context);

    context.read<RequestAssignmentDetailBloc>().add(GetRequestAssigmentDetail(id: id));
    context.read<RequestAssignmentListBloc>().add(const GetRequestAssigment());
  }

  DetailAssignmentRequestPageState({required this.id});
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
          const Spacer()
        ],
      ),
      body: BlocBuilder<RequestAssignmentDetailBloc,
          RequestAssignmentDetailState>(
        builder: (context, state) {
          if (state is RequestAssignmentDetailLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is RequestAssignmentDetailLoadSuccess) {
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
                      const SizedBox(
                        height: 20,
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
                                "Nomor Surat",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                assignment.number,
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
                                "Nama Penugasan",
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
                        child: GestureDetector(
                          onTap: () async {
                            ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

                            bool updated = await RequestRepository().cancelAssignmentRequest(id: id);
                            Navigator.pop(context);
                            if (updated) {
                              onCancle();
                            } else {
                              ModalBottomSheetComponent().errorIndicator(context, "Gagal mengirim data");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber),
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
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
