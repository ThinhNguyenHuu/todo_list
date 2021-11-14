import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:todo_list/utils/datetime.dart';
import 'package:todo_list/service/notification_service.dart';
import 'package:todo_list/service/data_access_service.dart';

class TodoDTO {
  final int id;
  final String taskName;
  final String description;
  final DateTime time;
  final bool hasNotification;
  final DateTime scheduledNotificationAt;
  TodoDTO(
      {required this.id,
      required this.taskName,
      required this.description,
      required this.time,
      required this.hasNotification,
      required this.scheduledNotificationAt});

  bool isSentNotification() {
    if (!hasNotification) {
      return false;
    }
    DateTime scheduledAt = scheduledNotificationAt;
    return scheduledAt.isBefore(DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'description': description,
      'time': time.toIso8601String(),
      'hasNotification': hasNotification ? 1 : 0,
      'scheduledNotificationAt': scheduledNotificationAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    String timeStr = time.toIso8601String();
    String scheduledNotificationAtStr = scheduledNotificationAt.toIso8601String();
    int hasNotificationInt = hasNotification ? 1 : 0;
    return 'Todo{id: $id, taskName: $taskName, description: $description, time: $timeStr, hasNotification: $hasNotificationInt, scheduledNotificationAt: $scheduledNotificationAtStr}';
  }
}

class TodoModel extends ChangeNotifier {
  final List<TodoDTO> _items = [];
  static int _availableId = 1;

  UnmodifiableListView<TodoDTO> get items => UnmodifiableListView(_items);

  void addFromDb(List<TodoDTO> todos) {
    _items.clear();
    _items.addAll(todos);
    _availableId = todos.length + 1;
    notifyListeners();
  }

  Future<void> add(taskName, description, DateTime time) async {
    DateTime scheduledAt = time.subtract(const Duration(minutes: 10));
    bool hasNoti = scheduledAt.isAfter(DateTime.now());
    TodoDTO newTodo = TodoDTO(
      id: _availableId,
      taskName: taskName,
      description: description,
      time: time,
      hasNotification: hasNoti,
      scheduledNotificationAt: scheduledAt,
    );
    _items.add(newTodo);
    _availableId++;
    await NotificationService().scheduleNotification(newTodo);
    await DataAccessService().insertTodo(newTodo);
    notifyListeners();
  }

  List<TodoDTO> getList(String type) {
    DateTime now = DateTime.now();
    if (type == 'all') {
      return items;
    } else if (type == 'today') {
      return items.where((item) => isSameDate(item.time, now)).toList();
    } else if (type == 'upcoming') {
      return items.where((item) => !isSameDate(item.time, now) && item.time.isAfter(now)).toList();
    }
    return [];
  }

  List<TodoDTO> getSearchList(String searchText) {
    if (searchText == '') {
      return items;
    }
    return items.where((item) => item.taskName.toLowerCase().contains(searchText.toLowerCase())).toList();
  }

  List<TodoDTO> getListItemHasNotification() {
    return items.where((item) => item.hasNotification == true).toList();
  }

  Future<void> remove(List<int> ids) async {
    _items.removeWhere((item) => ids.contains(item.id));
    await NotificationService().cancelNotifications(ids);
    await DataAccessService().deleteTodos(ids);
    notifyListeners();
  }

  TodoModel() {}
}
