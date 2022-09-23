import 'package:flutter/material.dart';
import 'package:time_tracker_null_safety/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  }) : super(
          child1: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color1: color,
          onPressed: onPressed,
        );
}
