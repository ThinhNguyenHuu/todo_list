import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:todo_list/screens/dashboard/row.dart';
import 'package:todo_list/navigation/routes.dart';
import 'package:todo_list/utils/datetime_picker.dart';
import 'package:todo_list/components/add_todo_modal/add_todo_modal.dart';
import 'package:todo_list/service/data_access_service.dart';
import 'package:todo_list/utils/toast.dart';

class RowItem {
  final Icon icon;
  final String text;
  final String type;
  RowItem(this.icon, this.text, this.type);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _todoTaskName = '';
  String _todoDescription = '';
  DateTime _todoTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    DataAccessService().retrieveTodos().then((todos) {
      Provider.of<TodoModel>(context, listen: false).addFromDb(todos);
    });
  }

  void _onChangeTaskName(text) {
    setState(() => _todoTaskName = text);
  }

  void _onChangeDescription(text) {
    setState(() => _todoDescription = text);
  }

  void onShowDateTimePicker(context) {
    showDateTimePicker(context, _todoTime, (result) {
      setState(() {
        _todoTime = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoModel todoModel = context.watch<TodoModel>();

    List<RowItem> listItemRowDashboard = [
      RowItem(
        const Icon(Icons.inbox, color: Colors.blue),
        'All',
        'all',
      ),
      RowItem(
        const Icon(Icons.calendar_today, color: Colors.green),
        'Today',
        'today',
      ),
      RowItem(
        const Icon(Icons.list_alt, color: Colors.purpleAccent),
        'Upcoming',
        'upcoming',
      )
    ];

    List<Widget> renderListRowDashboard() {
      List<Widget> list = [];
      for (var i = 0; i < listItemRowDashboard.length; i++) {
        list.add(RowDashboard(
          rowItem: listItemRowDashboard[i],
          haveBorderBottom: i != 2,
        ));
      }
      return list;
    }

    void handleAddNewTodo() async {
      if (_todoTaskName != '' && _todoDescription != '') {
        await todoModel.add(_todoTaskName, _todoDescription, _todoTime);
        ToastHelper.showToastSuccess('Added new todo successfully');
      } else {
        ToastHelper.showToastError('Failed to add new todo');
      }
      setState(() {
        _todoTaskName = '';
        _todoDescription = '';
        _todoTime = DateTime.now();
      });
    }

    void showAddTodoModal(context) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return AddTodoModal(
              context,
              _onChangeTaskName,
              _onChangeDescription,
              _todoTime,
              onShowDateTimePicker,
              handleAddNewTodo,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.view_list_outlined, color: Colors.white),
          onPressed: null,
        ),
        title: const Text('TODO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, Routes.notificationCentre),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFE6E6FA),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  children: renderListRowDashboard(),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTodoModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
