import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestAlertPermission: false,
      requestBadgePermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static const AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
    'channel Id',
    'channel name',
    channelDescription: 'your channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    badgeNumber: 0,
  );

  static const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iosNotificationDetails,
  );

  Future<void> showNotification(TodoDTO todo) async {
    String title = 'Remember to ${todo.taskName} at ${DateFormat('hh:mm').format(todo.time)}';
    await flutterLocalNotificationsPlugin.show(todo.id, title, todo.description, platformChannelSpecifics,
        payload: 'payload');
  }

  Future<void> scheduleNotification(TodoDTO todo) async {
    if (!todo.hasNotification) {
      return;
    }
    String title = 'Remember to ${todo.taskName} at ${DateFormat('hh:mm').format(todo.time)}';
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(todo.scheduledNotificationAt, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        todo.id, title, todo.description, scheduledDate, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(List<int> ids) async {
    List<Future> futures = [];
    for (var i = 0; i < ids.length; i++) {
      futures.add(flutterLocalNotificationsPlugin.cancel(ids[i]));
    }
    await Future.wait(futures);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
