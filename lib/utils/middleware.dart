import 'package:flutter/material.dart';

import '../components/modal_bottom_sheet_component.dart';
import '../page/login_page.dart';
import '../repositories/user_repository.dart';

class Middleware {
  Future<void> authenticated(BuildContext context, String token) async {    
    var user = await UserRepository().getUser(token);

    if (user.email == "") {
      // ignore: use_build_context_synchronously
      redirectToLogin(context);
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Sesi telah berakhir, silahkan Log-In ulang.");
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