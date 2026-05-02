import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'login_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void _showTaskDialog(BuildContext context,
      {String? taskId,
      String? title,
      String? description,
      DateTime? dueDate}) {
    final titleCtrl = TextEditingController(text: title);
    final descCtrl = TextEditingController(text: description);
    DateTime? selectedDate = dueDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(taskId == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setStateDialog(() => selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        selectedDate == null
                            ? 'Pick Due Date'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style: TextStyle(
                          color: selectedDate == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (taskId == null) {
                  await FirebaseService.createTask(
                      titleCtrl.text, descCtrl.text, selectedDate);
                } else {
                  await FirebaseService.updateTask(
                      taskId, titleCtrl.text, descCtrl.text, selectedDate);
                }
                Navigator.of(ctx).pop();
              },
              child: Text(taskId == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseService.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tasks yet!',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey)),
                  Text('Tap + to add a task',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          final tasks = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final data = task.data() as Map<String, dynamic>;
              final isCompleted = data['isCompleted'] ?? false;
              DateTime? dueDate;
              if (data['dueDate'] != null) {
                dueDate = (data['dueDate'] as Timestamp).toDate();
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: isCompleted,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      FirebaseService.toggleComplete(task.id, val ?? false);
                    },
                  ),
                  title: Text(
                    data['title'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['description'] ?? '',
                        style: TextStyle(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isCompleted ? Colors.grey : Colors.black54,
                        ),
                      ),
                      if (dueDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: dueDate.isBefore(DateTime.now()) &&
                                      !isCompleted
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: dueDate.isBefore(DateTime.now()) &&
                                        !isCompleted
                                    ? Colors.red
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showTaskDialog(
                          context,
                          taskId: task.id,
                          title: data['title'],
                          description: data['description'],
                          dueDate: dueDate,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Task'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  FirebaseService.deleteTask(task.id);
                                },
                                child: const Text('Delete',
                                    style:
                                        TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
