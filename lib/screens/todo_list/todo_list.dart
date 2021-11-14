import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/screens/todo_list/todo_item.dart';
import 'package:todo_list/utils/string.dart';
import 'package:todo_list/models/todo_dto.dart';
import 'package:todo_list/components/alert/alert.dart';
import 'package:todo_list/screens/todo_list/empty_list.dart';
import 'package:todo_list/utils/datetime_picker.dart';
import 'package:todo_list/components/add_todo_modal/add_todo_modal.dart';
import 'package:todo_list/utils/toast.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key, required this.args}) : super(key: key);

  final dynamic args;

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<int> _selectedIds = [];
  String _todoTaskName = '';
  String _todoDescription = '';
  DateTime _todoTime = DateTime.now();

  bool _isSearching = false;
  String _searchText = '';
  List<TodoDTO> _searchListTodo = [];

  void _onItemSelected(itemId) {
    var index = _selectedIds.indexOf(itemId);
    if (index == -1) {
      setState(() {
        _selectedIds = [..._selectedIds, itemId];
      });
    } else {
      setState(() {
        _selectedIds = [
          ..._selectedIds.sublist(0, index),
          ..._selectedIds.sublist(index + 1),
        ];
      });
    }
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
    List<TodoDTO> items = todoModel.getList(widget.args.type);

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

    void handleSearchTodo() {
      List<TodoDTO> searchItems = todoModel.getSearchList(_searchText);
      setState(() => _searchListTodo = searchItems);
    }

    void onChangeSearchText(text) {
      setState(() => _searchText = text);
      Future.delayed(const Duration(milliseconds: 300), handleSearchTodo);
    }

    void showAddTodoModal(context) {
      if (_isSearching) {
        return;
      }
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

    void showPopupConfirmDelete() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertCustom(
              context,
              'Delete completed tasks',
              'Are you sure you want to delete these completed tasks.',
              'Cancel',
              'Delete',
              Navigator.pop,
              (context) async {
                Navigator.pop(context);
                await todoModel.remove(_selectedIds);
                setState(() {
                  _selectedIds = [];
                  _isSearching = false;
                });
                ToastHelper.showToastSuccess('Deleted completed tasks successfully');
              },
            );
          });
    }

    Widget renderDeleteAction() {
      if (_selectedIds.isNotEmpty) {
        return IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.white),
          onPressed: showPopupConfirmDelete,
        );
      }
      return const SizedBox.shrink();
    }

    void onActionSearch() {
      setState(() {
        _selectedIds = [];
        _searchText = '';
        _isSearching = !_isSearching;
        _searchListTodo = items;
      });
    }

    Widget renderSearchList() {
      return Container(
          color: const Color(0xFFE6E6FA),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _searchListTodo.length,
            itemBuilder: (context, index) {
              TodoDTO item = _searchListTodo[index];
              return TodoItem(
                item: item,
                isChecked: _selectedIds.contains(item.id),
                onSelect: () {
                  _onItemSelected(item.id);
                },
              );
            },
          ));
    }

    AppBar renderAppBar() {
      if (_isSearching) {
        return AppBar(
            leading: GestureDetector(
                onTap: handleSearchTodo,
                child: const Icon(
                  Icons.search_outlined,
                )),
            title: TextField(
              onChanged: onChangeSearchText,
              decoration: const InputDecoration(
                hintText: 'Search something',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.white),
                onPressed: onActionSearch,
              ),
              renderDeleteAction(),
            ],
            automaticallyImplyLeading: false);
      }
      return AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(capitalize(widget.args.type)),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.white),
              onPressed: onActionSearch,
            ),
            renderDeleteAction(),
          ],
          automaticallyImplyLeading: false);
    }

    return Scaffold(
      appBar: renderAppBar(),
      body: _isSearching
          ? renderSearchList()
          : Container(
              color: const Color(0xFFE6E6FA),
              child: items.isEmpty
                  ? EmptyList()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        TodoDTO item = items[index];
                        return TodoItem(
                          item: item,
                          isChecked: _selectedIds.contains(item.id),
                          onSelect: () {
                            _onItemSelected(item.id);
                          },
                        );
                      },
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTodoModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
