import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/utils/colors.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.todoItem}) : super(key: key);

  final TodoDTO todoItem;

  @override
  Widget build(BuildContext context) {
    String notiTitle = 'Remember to ${todoItem.taskName} at ${DateFormat('hh:mm').format(todoItem.time)}';

    Widget renderNotificationStatus() {
      if (todoItem.isSentNotification()) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: const Icon(Icons.check, color: AppColors.green),
            ),
            const Text(
              'Sent',
              style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: const Icon(Icons.lock_clock, color: AppColors.red),
          ),
          const Text(
            'Waiting',
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: .5, color: Colors.grey)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(notiTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(todoItem.description),
            ),
            Container(
                margin: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renderNotificationStatus(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Scheduled at '),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 4, right: 4),
                              child: const Icon(Icons.calendar_today, color: AppColors.blue),
                            ),
                            Text(
                              DateFormat('d MMM, hh:mm').format(todoItem.scheduledNotificationAt),
                              style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
