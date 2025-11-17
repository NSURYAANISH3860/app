import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class EditScreen extends StatefulWidget {
  final Todo? todo;
  EditScreen({this.todo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime? _due;

  @override
  void initState() {
    super.initState();
    final t = widget.todo;
    if (t != null) {
      _title.text = t.title;
      _desc.text = t.description ?? '';
      _due = t.dueDate;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _due = d);
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final prov = Provider.of<TodoProvider>(context, listen: false);
    if (widget.todo == null) {
      await prov.add(_title.text.trim(), description: _desc.text.trim().isEmpty ? null : _desc.text.trim(), dueDate: _due);
    } else {
      await prov.update(widget.todo!.id, title: _title.text.trim(), description: _desc.text.trim().isEmpty ? null : _desc.text.trim(), dueDate: _due);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter title' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                decoration: InputDecoration(labelText: 'Description (optional)'),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_due == null ? 'No due date' : 'Due: ${DateFormat.yMMMd().format(_due!)}'),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Pick date'),
                    onPressed: _pickDate,
                  )
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Save')),
                  onPressed: _save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
