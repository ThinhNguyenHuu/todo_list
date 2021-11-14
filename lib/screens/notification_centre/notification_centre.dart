import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/screens/notification_centre/notification_item.dart';
import 'package:todo_list/screens/notification_centre/empty_list.dart';

class NotificationCentreScreen extends StatefulWidget {
  const NotificationCentreScreen({Key? key}) : super(key: key);

  @override
  State<NotificationCentreScreen> createState() => _NotificationCentreScreenState();
}

class _NotificationCentreScreenState extends State<NotificationCentreScreen> {
  @override
  Widget build(BuildContext context) {
    TodoModel todoModel = context.watch<TodoModel>();
    List<TodoDTO> todoItems = todoModel.getListItemHasNotification();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: Container(
            color: const Color(0xFFE6E6FA),
            child: todoItems.isEmpty
                ? EmptyList()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: todoItems.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(todoItem: todoItems[index]);
                    })));
  }
}
