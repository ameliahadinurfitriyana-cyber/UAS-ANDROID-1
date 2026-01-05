import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoApp/widgets/custom_date_time_picker.dart';
import 'package:todoApp/widgets/custom_modal_action_button.dart';
import 'package:todoApp/widgets/custom_textfield.dart';

class AddEventPage extends StatefulWidget {
  final Map<String, String>? eventToEdit;

  const AddEventPage({Key? key, this.eventToEdit}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.eventToEdit?['task'] ?? "");
    _descController =
        TextEditingController(text: widget.eventToEdit?['desc'] ?? "");
    _timeController =
        TextEditingController(text: widget.eventToEdit?['time'] ?? "Pick time");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future _pickDate() async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
    setState(() {
      _timeController.text = DateFormat('yyyy-MM-dd').format(datepick!);
    });
  }

  Future _pickTime() async {
    TimeOfDay? timepick =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timepick != null) {
      setState(() {
        _timeController.text = timepick.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
            widget.eventToEdit == null ? "Add new event" : "Edit event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          SizedBox(
            height: 24,
          ),
          CustomTextField(
              labelText: 'Enter event name', controller: _titleController),
          SizedBox(height: 12),
          CustomTextField(
              labelText: 'Enter description', controller: _descController),
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            value: _timeController.text,
          ),
          CustomDateTimePicker(
            icon: Icons.access_time,
            onPressed: _pickTime,
            value: _timeController.text,
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              Navigator.of(context).pop({
                "task": _titleController.text,
                "desc": _descController.text,
                "time": _timeController.text,
              });
            },
          )
        ],
      ),
    );
  }
}
