import 'package:flutter/material.dart';

void showDateTimePicker(context, initialDateTime, callback) async {
  FocusScope.of(context).requestFocus(FocusNode());
  DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: DateTime.now(),
    lastDate: DateTime(2023, 1, 1),
  );
  if (date == null) {
    return;
  }
  TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute),
  );
  if (time == null) {
    return;
  }
  DateTime datetimeResult = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  callback(datetimeResult);
}
