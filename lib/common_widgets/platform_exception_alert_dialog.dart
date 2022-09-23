import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_null_safety/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {required String title, required FirebaseException exception})
      : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );
  static String _message(FirebaseException exception) {
    return _errors[exception.code].toString();
  }

  static Map<String, String> _errors = {
    'wrong-password': 'The password is invalid',
    'permission-denied': 'Missing or insufficient premission',
  };
}
