import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/models/Employee/User.dart';
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
  
  List<User> _userEmployment = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<EmployeeBloc>().add(ScrollFetch(page: page));
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employee = BlocProvider.of<EmployeeBloc>(context);

    if (employee.state is! EmployeeLoadSuccess) {
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
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18),
                    child: Text("loading..."),
                  );
                } else if (state is EmployeeLoadFailure) {
                  return Text("Failed to load employee");
                } else if (state is EmployeeLoadSuccess) {
                  _userEmployment = state.employee;
                }

                return Column(
                  children: [
                    Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        Middleware().authenticated(context);
                        
                        context.read<EmployeeBloc>().add(GetEmployee());
                      },
                      child: ListView.builder(
                          controller: _userEmployment.length > 9 ? _scrollController : null,
                          itemCount: _userEmployment.length,
                          itemBuilder: (BuildContext context, int index) {
                            var user = _userEmployment[index];
                      
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
                        ),
                      ),
                    ),
                    (state is EmployeeFetchNew)
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: 40,
                            child: Text("Loading..."),
                          ),
                        )
                      : const SizedBox(),
                  ],
                );
            
              },
            ),
          ),
        ],
      ),
    );
  }
}
