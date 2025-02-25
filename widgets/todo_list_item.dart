import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.finished,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) finished;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        actionExtentRatio: 0.25,
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              widget.onDelete(widget.todo);
            },
          )
        ],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xffFFDFDF),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  if (value != null && value) {
                    setState(() {
                      isChecked = value;
                    });
                    isChecked = false;
                    widget.finished(widget.todo);
                  }
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(widget.todo.dateTime),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}