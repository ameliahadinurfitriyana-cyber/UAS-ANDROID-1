import 'package:flutter/material.dart';
import 'package:todoApp/widgets/custom_icon_decoration.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Event {
  final String time;
  final String task;
  final String desc;
  final bool isFinish;

  const Event(this.time, this.task, this.desc, this.isFinish);

  Event copyWith({String? time, String? task, String? desc, bool? isFinish}) {
    return Event(
      time ?? this.time,
      task ?? this.task,
      desc ?? this.desc,
      isFinish ?? this.isFinish,
    );
  }
}

List<Event> _eventList = [
  Event("08:00", "Have coffe with Sam", "Personal", true),
  Event("10:00", "Meet with sales", "Work", true),
  Event("12:00", "Call Tom about appointment", "Work", false),
  Event("14:00", "Fix onboarding experience", "Work", false),
  Event("16:00", "Edit API documentation", "Personal", false),
  Event("18:00", "Setup user focus group", "Personal", false),
];

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    double iconSize = 20;

    return ListView.builder(
      itemCount: _eventList.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Row(
            children: <Widget>[
              _lineStyle(context, iconSize, index, _eventList.length,
                  _eventList[index].isFinish),
              _displayTime(_eventList[index].time),
              _displayContent(_eventList[index], index)
            ],
          ),
        );
      },
    );
  }

  Widget _displayContent(Event event, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.task),
              SizedBox(
                height: 12,
              ),
              Text(event.desc),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => _openEditDialog(event, index),
                    tooltip: "Edit event",
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.redAccent,
                    onPressed: () => _confirmDelete(index),
                    tooltip: "Delete event",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0,
            lastData: index == listLength - 1),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0x20000000),
                    blurRadius: 5)
              ]),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Theme.of(context).colorScheme.secondary),
        ));
  }

  void _confirmDelete(int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete event"),
            content: const Text("Are you sure you want to delete this event?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _eventList.removeAt(index);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete")),
            ],
          );
        });
  }

  void _openEditDialog(Event event, int index) {
    final titleController = TextEditingController(text: event.task);
    final descController = TextEditingController(text: event.desc);
    final timeController = TextEditingController(text: event.time);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Edit event"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: "Time"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _eventList[index] = event.copyWith(
                        task: titleController.text,
                        desc: descController.text,
                        time: timeController.text,
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }
}
