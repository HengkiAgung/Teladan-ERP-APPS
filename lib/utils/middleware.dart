// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/attendance_log/attendance_log_bloc.dart' as attendance_log_bloc;
import '../../bloc/attendance_today/attendance_today_bloc.dart' as attendance_today_bloc;
import '../../bloc/employee/employee_bloc.dart' as employee_bloc;
import '../../bloc/request_attendance_list/request_attendance_list_bloc.dart' as request_attendance_list_bloc;
import '../../bloc/request_leavel_list/request_leave_list_bloc.dart' as request_leave_list_bloc;
import '../../bloc/request_shift_list/request_shift_list_bloc.dart' as request_shift_list_bloc;
import '../../bloc/summaries/summaries_bloc.dart' as summaries_bloc;
import '../components/modal_bottom_sheet_component.dart';
import '../page/login_page.dart';
import '../repositories/user_repository.dart';
import 'auth.dart';

class Middleware {
  Future<void> authenticated(BuildContext context) async { 
    String token = await Auth().getToken();   
    if (token != "") {
      var user = await UserRepository().getUser(token);

      if (user.email == "") {
        Auth().logOut(context);

        ModalBottomSheetComponent().errorIndicator(context, "Sesi telah berakhir, silahkan Log-In ulang.");
      }
    }
  }


  void redirectToLogin(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    while (navigator != null && navigator.canPop()) {
      Navigator.pop(context);
    }
    
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
  }
}