import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:teladan/page/auth/reset_password_page.dart';

import 'bloc/approval_detail/approval_detail_bloc.dart';
import 'bloc/approval_list/approval_list_bloc.dart';
import 'bloc/attendance_detail/attendance_detail_bloc.dart';
import 'bloc/attendance_today/attendance_today_bloc.dart';
import 'bloc/employee/employee_bloc.dart';
import 'bloc/request_attendance_list/request_attendance_list_bloc.dart';
import 'bloc/request_detail/request_detail_bloc.dart';
import 'bloc/request_leavel_list/request_leave_list_bloc.dart';
import 'bloc/request_shift_list/request_shift_list_bloc.dart';
import 'bloc/summaries/summaries_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'bloc/attendance_log/attendance_log_bloc.dart';
import 'page/auth/login_page.dart';
import 'page/main_page.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ApprovalListBloc>(
        create: (context) => ApprovalListBloc(),
      ),
      BlocProvider<ApprovalDetailBloc>(
        create: (context) => ApprovalDetailBloc(),
      ),
      BlocProvider<AttendanceTodayBloc>(
        create: (context) => AttendanceTodayBloc(),
      ),
      BlocProvider<AttendanceDetailBloc>(
        create: (context) => AttendanceDetailBloc(),
      ),
      BlocProvider<AttendanceLogBloc>(
        create: (context) => AttendanceLogBloc(),
      ),
      BlocProvider<EmployeeBloc>(
        create: (context) => EmployeeBloc(),
      ),
      BlocProvider<RequestDetailBloc>(
        create: (context) => RequestDetailBloc(),
      ),
      BlocProvider<RequestAttendanceListBloc>(
        create: (context) => RequestAttendanceListBloc(),
      ),
      BlocProvider<RequestShiftListBloc>(
        create: (context) => RequestShiftListBloc(),
      ),
      BlocProvider<RequestLeaveListBloc>(
        create: (context) => RequestLeaveListBloc(),
      ),
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
      ),
      BlocProvider<SummariesBloc>(
        create: (context) => SummariesBloc(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(GetUser());

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.amber,
            secondary: const Color(0xFFFFC107),
          ),
        ),
        home: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/logo-comtel-nig.png', // Replace with your logo asset path
                        width: 100.0, // Adjust the width as needed
                        height: 100.0, // Adjust the height as needed
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Teladan by Comtelindo',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Loading... ',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserLoadSuccess) {
              return state.user.id != 0
                  ? state.user.is_new
                      ? ResetPasswordPage()
                      : MainPage(index: 0)
                  : const LoginPage();
            } else {
              return MainPage(
                index: 0,
                error: true,
              );
            }
          },
        ));
  }
}
