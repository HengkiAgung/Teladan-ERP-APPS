import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Employee/User.dart';
import '../repositories/employee_repository.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 12),
            margin: EdgeInsetsDirectional.only(top: 20),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "Daftar Karyawan",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: EmployeeRepository().getAllUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the result, you can show a loading indicator.
                  // return const CircularProgressIndicator();
                  return const Text('Loading');
                } else if (snapshot.hasError) {
                  // Handle the error case here.
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount:
                        snapshot.data == null ? 0 : snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var user = snapshot.data![index];
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
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                user.foto_file != ""
                                    ? CircleAvatar(
                                        radius: 25, // Image radius
                                        backgroundImage:
                                            NetworkImage(user.foto_file))
                                    : const CircleAvatar(
                                        radius: 25, // Image radius
                                        backgroundImage: AssetImage(
                                            "images/profile_placeholder.jpg"),
                                      ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 51, 51, 51),
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      user.kontak,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => launch("tel://${user.kontak}"),
                                  child: Icon(Icons.phone),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () => launch("mailto:${user.email}"),
                                  child: Icon(Icons.mail_outline, size: 25, color: Colors.red),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      launch("https://wa.me/${user.kontak}"),
                                  child: const Image(
                                    height: 23,
                                    image: AssetImage("images/whatsapp.png"),
                                  ),
                                ),
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
