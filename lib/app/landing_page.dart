import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_null_safety/Services/auth.dart';
import 'package:time_tracker_null_safety/Services/database.dart';
import 'package:time_tracker_null_safety/app/home/home_page.dart';
import 'package:time_tracker_null_safety/app/sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserProgram?>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserProgram? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<UserProgram>.value(
            value: user,
            child: Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid!),
              child: HomePage(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
