import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child1,
    this.color1,
    this.borderRadius: 2.0,
    this.height: 50.0,
    this.onPressed,
  });
  final Widget? child1;
  final Color? color1;
  final double? borderRadius;
  final double? height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius!),
            ),
          ),
        ),
        child: child1,
        onPressed: onPressed,
      ),
    );
  }
}
