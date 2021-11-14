import 'package:flutter/material.dart';

Widget AlertCustom(
  BuildContext context,
  title,
  description,
  leftText,
  rightText,
  onLeftPressed,
  onRightPressed,
) {
  return AlertDialog(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text(description),
    actions: <Widget>[
      TextButton(
        onPressed: () => onLeftPressed(context),
        child: Text(
          leftText,
          style: const TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          backgroundColor: Colors.blue,
        ),
      ),
      TextButton(
        onPressed: () => onRightPressed(context),
        child: Text(rightText, style: const TextStyle(color: Colors.white)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          backgroundColor: Colors.red,
        ),
      ),
    ],
  );
}
