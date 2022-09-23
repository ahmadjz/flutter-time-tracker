import 'package:flutter/material.dart';
import 'package:time_tracker_null_safety/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child1: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color1: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
