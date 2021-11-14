import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.item,
    required this.isChecked,
    required this.onSelect,
  }) : super(key: key);

  final TodoDTO item;
  final bool isChecked;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    Widget renderTime() {
      return (Container(
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: const Icon(Icons.calendar_today, color: Colors.red),
              ),
              Text(
                DateFormat('d MMM, hh:mm').format(item.time),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          )));
    }

    return (GestureDetector(
        onTap: onSelect,
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(width: .5, color: Colors.grey)),
              color: isChecked ? Colors.white54 : Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          onChanged: null,
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                        ))),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.taskName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(item.description, style: const TextStyle(fontSize: 16)),
                    ),
                    renderTime(),
                  ],
                ))
              ],
            ))));
  }
}
