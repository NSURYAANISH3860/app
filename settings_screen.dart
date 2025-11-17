import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.cleaning_services),
              title: Text('Clear completed tasks'),
              subtitle: Text('Removes all tasks marked as done'),
              onTap: () async {
                await prov.clearCompleted();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Completed cleared')));
              },
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              subtitle: Text('Final assignment: To-Do with Provider & persistence'),
            )
          ],
        ),
      ),
    );
  }
}
