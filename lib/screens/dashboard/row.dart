import 'package:flutter/material.dart';
import 'package:todo_list/navigation/routes.dart';
import 'package:todo_list/navigation/arguments.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:provider/provider.dart';

class RowDashboard extends StatelessWidget {
  const RowDashboard({
    Key? key,
    required this.rowItem,
    this.haveBorderBottom = true,
  }) : super(key: key);

  final bool haveBorderBottom;
  final dynamic rowItem;

  @override
  Widget build(BuildContext context) {
    TodoModel todoModel = context.watch<TodoModel>();

    void navigateTodoList() {
      Navigator.pushNamed(context, Routes.todoList, arguments: TodoListScreenArguments(rowItem.type));
    }

    return (GestureDetector(
        onTap: navigateTodoList,
        child: Container(
            child: Row(
          children: [
            Container(padding: const EdgeInsets.all(16), child: rowItem.icon),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: haveBorderBottom
                        ? const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)))
                        : const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rowItem.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(todoModel.getList(rowItem.type).length.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    )))
          ],
        ))));
  }
}
