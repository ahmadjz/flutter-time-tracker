import 'dart:io';

import 'package:time_tracker_null_safety/common_widgets/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {required this.title,
      this.cancelActionText,
      required this.content,
      required this.defaultActionText});
  final String title;
  final String? content;
  final String? cancelActionText;
  final String defaultActionText;

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidger(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(cancelActionText!),
      ));
    }
    actions.add(
      PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText),
      ),
    );
    return actions;
  }
}

//this code is working for ios but I can't understand what is the porpuse of it
class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidger(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
