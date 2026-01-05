import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoApp/model/database.dart';
import 'package:todoApp/model/todo.dart';
import 'package:todoApp/widgets/custom_date_time_picker.dart';
import 'package:todoApp/widgets/custom_modal_action_button.dart';
import 'package:todoApp/widgets/custom_textfield.dart';

class AddTaskPage extends StatefulWidget {
  final TodoData? taskToEdit;

  const AddTaskPage({Key? key, this.taskToEdit}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late DateTime _selectedDate;
  late TextEditingController _textTaskControler;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.taskToEdit?.date ?? DateTime.now();
    _textTaskControler =
        TextEditingController(text: widget.taskToEdit?.task ?? "");
  }

  @override
  void dispose() {
    _textTaskControler.dispose();
    super.dispose();
  }

  Future _pickDate() async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    setState(() {
      _selectedDate = datepick ?? _selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Database>(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
            widget.taskToEdit == null ? "Add new task" : "Edit task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          SizedBox(
            height: 24,
          ),
          CustomTextField(
              labelText: 'Enter task name', controller: _textTaskControler),
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              if (_textTaskControler.text == "") {
                print("data not found");
              } else {
                final now = DateTime.now();

                final saveFuture = widget.taskToEdit == null
                    ? provider.insertTodoEntries(TodoCompanion.insert(
                        date: _selectedDate,
                        time: now,
                        isFinish: false,
                        task: _textTaskControler.text,
                        description: widget.taskToEdit?.description ?? "",
                        todoType: TodoType.TYPE_TASK.index,
                      ))
                    : provider.updateTodoEntries(TodoData(
                        date: _selectedDate,
                        time: widget.taskToEdit?.time ?? now,
                        isFinish: widget.taskToEdit?.isFinish ?? false,
                        task: _textTaskControler.text,
                        description: widget.taskToEdit?.description ?? "",
                        todoType: TodoType.TYPE_TASK.index,
                        id: widget.taskToEdit!.id,
                      ));

                saveFuture.whenComplete(() => Navigator.of(context).pop());
              }
            },
          )
        ],
      ),
    );
  }
}
