import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../models/Attendance.dart';
import '../../repositories/attendance_repository.dart';

class DetailAttendance extends StatelessWidget {
  final String date;
  const DetailAttendance({super.key, required this.date});

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
                "Detail Attendance",
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
      body: FutureBuilder<Attendance>(
        future: AttendanceRepository().getAttendanceDetail(date),
        builder: (BuildContext context, AsyncSnapshot<Attendance> snapshot) {
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
            return ListView(
              children: [
                snapshot.data!.check_in_latitude != 0
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 25),
                            child: Center(
                              child: Text(
                                "Check-In",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 200,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(
                                        snapshot.data!.check_in_latitude,
                                        snapshot.data!.check_in_longitude,
                                      ),
                                      zoom: 14,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: LatLng(
                                                snapshot
                                                    .data!.check_in_latitude,
                                                snapshot
                                                    .data!.check_in_longitude),
                                            width: 20,
                                            height: 20,
                                            builder: (context) => const Icon(
                                                Icons.location_on_outlined),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage("images/loading.gif"),
                                    image: NetworkImage(
                                        snapshot.data!.check_in_file),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Waktu Clock In",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.check_in != ""
                                        ? snapshot.data!.check_in
                                            .split(' ')[1]
                                            .substring(0, 5)
                                        : "-",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shift",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.shift_name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Jadwal Shift",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.date,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lokasi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Lihat Lokasi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 25),
                        child: Center(
                          child: Text(
                            "Belum Check-In nih.. 💼",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                snapshot.data!.check_out_latitude != 0
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 25),
                            child: Center(
                              child: Text(
                                "Check-Out",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Row(
                              children: [
                                Container(
                                  width: 200,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(snapshot.data!.check_out_latitude,
                                        snapshot.data!.check_out_longitude,
                                      ),
                                      zoom: 0,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: LatLng(
                                                snapshot
                                                    .data!.check_out_latitude,
                                                snapshot
                                                    .data!.check_out_longitude),
                                            width: 20,
                                            height: 20,
                                            builder: (context) => const Icon(
                                                Icons.location_on_outlined),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text("Ini Image"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Waktu Clock Out",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.check_out,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shift",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.shift_name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Jadwal Shift",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.date,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lokasi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Lihat Lokasi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 25),
                        child: Center(
                          child: Text(
                            "Belum Check-Out nih.. 💼",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}
