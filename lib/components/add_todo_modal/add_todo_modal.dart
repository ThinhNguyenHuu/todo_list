import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/components/view_button_bottom/view_button_bottom.dart';

Widget AddTodoModal(
  BuildContext context,
  onChangeTaskName,
  onChangeDescription,
  time,
  onShowDateTimePicker,
  onDone,
) {
  return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 320,
        padding: const EdgeInsets.all(24),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Task to do',
              ),
              onChanged: onChangeTaskName,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
                onChanged: onChangeDescription,
              ),
            ),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(DateFormat('d MMM, hh:mm').format(time),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              onTap: () => onShowDateTimePicker(context),
            ),
            ViewButtonBottom(
              leftText: 'Cancel',
              rightText: 'Done',
              leftPressed: () => Navigator.pop(context),
              rightPressed: () {
                Navigator.pop(context);
                onDone();
              },
            )
          ],
        ),
      ));
}
