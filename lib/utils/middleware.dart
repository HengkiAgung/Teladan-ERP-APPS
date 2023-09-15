import 'package:flutter/material.dart';

import '../components/error_notification_component.dart';
import '../models/Employee/User.dart';
import '../page/login_page.dart';
import '../repositories/user_repository.dart';
import 'auth.dart';

class Middleware {
  Future<void> authenticated(BuildContext context, User user) async {    

    if (user.email == "") {
      // ignore: use_build_context_synchronously
      redirectToLogin(context);
      ErrorNotificationComponent().showModal(context, "Sesi telah berakhir, silahkan Log-In ulang 😉");
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