import 'package:flutter/material.dart';

import 'page/login_page.dart';
import 'page/main_page.dart';
import 'utils/auth.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> isLogin(BuildContext context) async {
    var token = await Auth().getToken();
    if (token == null) {
      return false;
    } 

    var user = await Auth().getUser(context);

    return user != null;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.amber,
          secondary: const Color(0xFFFFC107),
        ),
      ),
      home: FutureBuilder<bool>(
        future: isLogin(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            // Use the snapshot data to determine which widget to show.
            return snapshot.data ?? false ? MainPage(index: 0) : LoginPage();
          }
        },
      ),
    );
  }
}
