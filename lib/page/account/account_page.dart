import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/page/account/employment_page.dart';
import 'package:teladan/page/account/payroll/payroll_page.dart';
import 'package:teladan/utils/auth.dart';
import 'package:teladan/utils/middleware.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/attendance_log/attendance_log_bloc.dart' as attendance_log_bloc;
import '../../bloc/attendance_today/attendance_today_bloc.dart' as attendance_today_bloc;
import '../../bloc/employee/employee_bloc.dart' as employee_bloc;
import '../../bloc/request_attendance_list/request_attendance_list_bloc.dart' as request_attendance_list_bloc;
import '../../bloc/request_leavel_list/request_leave_list_bloc.dart' as request_leave_list_bloc;
import '../../bloc/request_shift_list/request_shift_list_bloc.dart' as request_shift_list_bloc;
import '../../bloc/summaries/summaries_bloc.dart' as summaries_bloc;
import '../../bloc/user/user_bloc.dart';
import '../../components/avatar_profile_component.dart';
import 'personal_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final account = BlocProvider.of<UserBloc>(context);

    if (account.state is! UserLoadSuccess) {
      context.read<UserBloc>().add(GetUser());
    }

    return ListView(
      children: [
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Text('Loading...');
            } else if (state is UserLoadSuccess) {
                return AvatarProfileComponent(
                  user: state.user,
                );
            }
            return const Text('Failed to load user data');
          },
        ),

        // Info Saya
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Info Saya",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info Personal
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.account_circle),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info Personal',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                        Text(
                          'Informasi pribadi',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info Pekerjaan
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmploymentPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.perm_contact_cal_rounded),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info Pekerjaan',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                        Text(
                          'Informasi terkait pekerjaan atau kantor',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info payroll
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PayrollPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.payments_rounded),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info payroll',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                        Text(
                          'Dafter anggota keluarga karyawan',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // kujungi web
        GestureDetector(
          onTap: () {
            launch("https://erp.comtelindo.com/");
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.web_asset),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Kunjungi website',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // Log Out
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Auth().deleteToken();
                  context.read<attendance_log_bloc.AttendanceLogBloc>().add(attendance_log_bloc.LogOut());
                  context.read<attendance_today_bloc.AttendanceTodayBloc>().add(attendance_today_bloc.LogOut());
                  context.read<employee_bloc.EmployeeBloc>().add(employee_bloc.LogOut());
                  context.read<request_attendance_list_bloc.RequestAttendanceListBloc>().add(request_attendance_list_bloc.LogOut());
                  context.read<request_leave_list_bloc.RequestLeaveListBloc>().add(request_leave_list_bloc.LogOut());
                  context.read<request_shift_list_bloc.RequestShiftListBloc>().add(request_shift_list_bloc.LogOut());
                  context.read<summaries_bloc.SummariesBloc>().add(summaries_bloc.LogOut());

                  Middleware().redirectToLogin(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Log Out',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
