import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/approval/approval_bloc.dart';
import 'bloc/attendance_detail/attendance_detail_bloc.dart';
import 'bloc/employee/employee_bloc.dart';
import 'bloc/request/request_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'bloc/attendance_daily/attendance_daily_bloc.dart';
import 'bloc/attendance_log/attendance_log_bloc.dart';
import 'page/login_page.dart';
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
      BlocProvider<ApprovalBloc>(
        create: (context) => ApprovalBloc(),
      ),
      BlocProvider<AttendanceDailyBloc>(
        create: (context) => AttendanceDailyBloc(),
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
      BlocProvider<RequestBloc>(
        create: (context) => RequestBloc(),
      ),
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
      ),
    ],
    child: Container(),
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
                    const SizedBox(height: 10,),
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
              return state.user.id == 0 ? MainPage(index: 0) : const LoginPage();
          } else {
            return MainPage(index: 0, error: true,);
          }
        },
      )
    );
  }
}
