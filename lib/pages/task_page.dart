import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoApp/model/database.dart';
import 'package:todoApp/model/todo.dart';
import 'package:todoApp/pages/add_task_page.dart';
import 'package:todoApp/widgets/custom_button.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Database provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    return StreamProvider<List<TodoData>>.value(
      initialData: [],
      value: provider.getTodoByType(TodoType.TYPE_TASK.index),
      child: Consumer<List<TodoData>>(
        builder: (context, _dataList, child) {
          if (_dataList.isEmpty) {
            return _emptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _dataList.length,
            itemBuilder: (context, index) {
              return _dataList[index].isFinish
                  ? _taskComplete(_dataList[index])
                  : _taskUncomplete(_dataList[index]);
            },
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle_outline, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text("No tasks yet. Tap + to add one."),
        ],
      ),
    );
  }

  Widget _taskUncomplete(TodoData data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _confirmComplete(data),
        onLongPress: () => _confirmDelete(data),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.radio_button_unchecked,
                color: Theme.of(context).colorScheme.secondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.task,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat("dd MMM yyyy").format(data.date),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => _openEditDialog(data),
                tooltip: "Edit task",
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
                onPressed: () => _confirmDelete(data),
                tooltip: "Delete task",
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskComplete(TodoData data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.task,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat("dd MMM yyyy").format(data.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _openEditDialog(data),
              tooltip: "Edit task",
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              onPressed: () => _confirmDelete(data),
              tooltip: "Delete task",
            )
          ],
        ),
      ),
    );
  }

  void _confirmComplete(TodoData data) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Confirm Task",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  Text(data.task),
                  const SizedBox(height: 24),
                  Text(DateFormat("dd-MM-yyyy").format(data.date)),
                  const SizedBox(height: 24),
                  CustomButton(
                    buttonText: "Complete",
                    onPressed: () {
                      provider
                          .completeTodoEntries(data.id)
                          .whenComplete(() => Navigator.of(context).pop());
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          );
        });
  }

  void _openEditDialog(TodoData data) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: AddTaskPage(taskToEdit: data),
          );
        });
  }

  void _confirmDelete(TodoData data) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete task"),
            content: const Text("Are you sure you want to delete this task?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    provider
                        .deleteTodoEntries(data.id)
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  child: const Text("Delete")),
            ],
          );
        });
  }
}
