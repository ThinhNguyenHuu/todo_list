import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/screens/dashboard/dashboard.dart';
import 'package:todo_list/screens/todo_list/todo_list.dart';
import 'package:todo_list/screens/notification_centre/notification_centre.dart';
import 'package:todo_list/navigation/routes.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:todo_list/service/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestIOSPermissions();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: Routes.dashboard,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.dashboard:
              return MaterialPageRoute(builder: (_) => const DashboardScreen());
            case Routes.notificationCentre:
              return MaterialPageRoute(builder: (_) => const NotificationCentreScreen());
            case Routes.todoList:
              return MaterialPageRoute(builder: (_) => TodoListScreen(args: settings.arguments));
          }
        },
      ),
    );
  }
}
