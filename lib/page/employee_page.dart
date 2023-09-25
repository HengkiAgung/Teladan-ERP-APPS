import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/employee/employee_bloc.dart';
import '../utils/middleware.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    final employee = BlocProvider.of<EmployeeBloc>(context);

    if (employee.state is! EmployeeLoadSuccess) {
      // print("checkAuth");
      // context.read<UserBloc>().add(CheckAuth());
      // print("read user");
      // final user = BlocProvider.of<UserBloc>(context);
      // if (user.state is UserUnauthenticated) {
      //   print("unauth");
      //   ModalBottomSheetComponent().errorIndicator(context, "Sesi telah berakhir, silahkan Log-In ulang.");
      //   // Auth().logOut(context);
      // }
      Middleware().authenticated(context);

      context.read<EmployeeBloc>().add(GetEmployee()); 
    }

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
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Text('Loading');
                } else if (state is EmployeeLoadSuccess) {
                  return ListView.builder(
                    itemCount: state.employee.length,
                    itemBuilder: (BuildContext context, int index) {
                      var user = state.employee[index];

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
                                      user.kontak != ""
                                          ? "+62 ${user.kontak}"
                                          : "",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => launch("tel:0${user.kontak}"),
                                  child: Icon(Icons.phone),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () => launch("mailto:${user.email}"),
                                  child: Icon(Icons.mail_outline,
                                      size: 25, color: Colors.red),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      launch("https://wa.me/+62${user.kontak}"),
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
                return const Text('Error to load employee');
              },
            ),
          ),
        ],
      ),
    );
  }
}
