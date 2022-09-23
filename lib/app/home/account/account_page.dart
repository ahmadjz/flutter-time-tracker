import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_null_safety/Services/auth.dart';
import 'package:time_tracker_null_safety/common_widgets/avatar.dart';
import 'package:time_tracker_null_safety/common_widgets/platform_alert_dialog.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestsignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to log out?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestsignOut == true) {
      _signOut(context);
    }
  }

  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgram>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            ),
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserProgram user) {
    return Column(
      children: <Widget>[
        Avatar(
          radius: 50,
          photoUrl: user.photoUrl,
        ),
        SizedBox(
          height: 8,
        ),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
