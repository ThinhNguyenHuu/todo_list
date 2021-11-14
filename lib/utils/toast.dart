import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list/utils/colors.dart';

class ToastHelper {
  static void _showToast(msg, color) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  static void showToastSuccess(msg) {
    _showToast(msg, AppColors.green);
  }

  static void showToastError(msg) {
    _showToast(msg, AppColors.red);
  }
}
