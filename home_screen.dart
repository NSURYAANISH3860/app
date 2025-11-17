import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import 'edit_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TodoProvider>(context);
    final list = prov.items.where((t) {
      if (q.isEmpty) return true;
      final s = q.toLowerCase();
      return t.title.toLowerCase().contains(s) || (t.description ?? '').toLowerCase().contains(s);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen())),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _searchField(),
          ),
        ),
      ),
      body: list.isEmpty ? _emptyState() : _listView(list),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditScreen())),
      ),
    );
  }

  Widget _searchField() => TextField(
    decoration: InputDecoration(
      hintText: 'Search tasks...',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    ),
    onChanged: (v) => setState(() => q = v),
  );

  Widget _emptyState() => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 72, color: Colors.grey),
          SizedBox(height: 12),
          Text('No tasks yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tap + to add your first task.'),
        ],
      ),
    ),
  );

  Widget _listView(List<Todo> list) => ListView.separated(
    padding: EdgeInsets.all(8),
    itemCount: list.length,
    separatorBuilder: (_,__) => SizedBox(height: 8),
    itemBuilder: (ctx, i) {
      final t = list[i];
      return Slidable(
        key: ValueKey(t.id),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.45,
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditScreen(todo: t))),
              backgroundColor: Colors.blue,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => Provider.of<TodoProvider>(context, listen: false).remove(t.id),
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            leading: Checkbox(
              value: t.done,
              onChanged: (_) => Provider.of<TodoProvider>(context, listen: false).toggleDone(t.id),
            ),
            title: Text(
              t.title,
              style: TextStyle(decoration: t.done ? TextDecoration.lineThrough : null),
            ),
            subtitle: t.dueDate == null ? (t.description == null ? null : Text(t.description!)) : Text(
              '${t.description ?? ''}\nDue: ${DateFormat.yMMMd().format(t.dueDate!)}',
            ),
            isThreeLine: t.dueDate != null,
            trailing: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditScreen(todo: t))),
            ),
          ),
        ),
      );
    },
  );
}
