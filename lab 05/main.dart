import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: const HomeScreen(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(title: 'Learn Flutter'),
    Task(title: 'Create a To-Do List App'),
    Task(title: 'Implement State Management'),
  ];

  final TextEditingController _taskController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();

  void _addTask() {
    final String taskTitle = _taskController.text.trim();

    if (taskTitle.isEmpty) {
      // Show error message for empty task
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task title cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(title: taskTitle));
      _taskController.clear();
      _taskFocusNode
          .requestFocus(); // Keep focus on the text field after adding
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _tasks.insert(index, Task(title: _taskController.text));
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _taskFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear completed tasks',
            onPressed: () {
              if (_tasks.any((task) => task.isCompleted)) {
                setState(() {
                  _tasks.removeWhere((task) => task.isCompleted);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completed tasks cleared')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Task Input Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    focusNode: _taskFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'New Task',
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),

          // Task Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks: ${_tasks.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Completed: ${_tasks.where((task) => task.isCompleted).length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1),

          // Task List
          Expanded(
            child:
                _tasks.isEmpty
                    ? const Center(
                      child: Text(
                        'No tasks yet. Add a new task!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (_) => _toggleTaskCompletion(index),
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    task.isCompleted
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
