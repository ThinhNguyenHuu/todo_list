import 'package:flutter/material.dart';

Widget EmptyList() {
  return Center(
      child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          color: const Color(0xFFE6E6FA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "There's no TODO yet.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                "Press plus button to add new TODO.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          )));
}
