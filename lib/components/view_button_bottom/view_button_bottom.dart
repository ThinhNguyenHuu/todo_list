import 'package:flutter/material.dart';

class ViewButtonBottom extends StatelessWidget {
  const ViewButtonBottom({
    Key? key,
    required this.leftText,
    required this.rightText,
    required this.leftPressed,
    required this.rightPressed,
  }) : super(key: key);

  final String leftText;
  final String rightText;

  final VoidCallback leftPressed;
  final VoidCallback rightPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: TextButton(
                          onPressed: leftPressed,
                          child: Text(
                            leftText,
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            backgroundColor: Colors.blue,
                          ),
                        ))),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextButton(
                          onPressed: rightPressed,
                          child: Text(rightText, style: const TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            backgroundColor: Colors.red,
                          ),
                        ))),
              ],
            )));
  }
}
