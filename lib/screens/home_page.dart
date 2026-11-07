
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _priority;

  final Color green = const Color(0xFF52745B);
  final Color darkGreen = const Color(0xFF344B39);
  final Color background = const Color(0xFFF8F8F5);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      await context.read<TaskCubit>().addTask(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            priority: _priority!,
          );

      if (!mounted) return;

      final state = context.read<TaskCubit>().state;

      if (state is TaskSuccess) {
        _titleController.clear();
        _descriptionController.clear();

        setState(() {
          _priority = null;
        });

        _formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully! ✨'),
            backgroundColor: Color(0xFF52745B),
          ),
        );
      }
    }
  }

  Color _priorityColor(String priority) {
    if (priority == 'High') {
      return const Color(0xFFF8DEDA);
    } else if (priority == 'Medium') {
      return const Color(0xFFFFEDCF);
    } else {
      return const Color(0xFFE2EFDF);
    }
  }

  Color _taskColor(int index) {
    final colors = [
      const Color(0xFFFFF8E9),
      const Color(0xFFEDF4EC),
      const Color(0xFFF2ECF8),
      const Color(0xFFFCEEF0),
    ];

    return colors[index % colors.length];
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF819782),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F8F5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF9BB69D),
          width: 1.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskInitial || state is TaskLoading) {
          return Scaffold(
            backgroundColor: background,
            body: Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            ),
          );
        }

        if (state is TaskError) {
          return Scaffold(
            backgroundColor: background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskCubit>().loadTasks();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! TaskSuccess) {
          return const SizedBox.shrink();
        }

        final tasks = state.tasks;

        final completedTasks = tasks
            .where((task) => task['completed'] == true)
            .length;

        final totalTasks = tasks.length;

        final double progress = totalTasks == 0
            ? 0
            : completedTasks / totalTasks;

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
            elevation: 0,
            title: Text(
              'Task Manager',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFE7F0E8),
                  child: Icon(
                    Icons.checklist_rounded,
                    color: green,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE7F0E8),
                        Color(0xFFF4F0E3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, there! ☀️',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: darkGreen,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  'Make today a good one.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF718273),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.wb_sunny_rounded,
                            size: 48,
                            color: Color(0xFFD3A94E),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'YOUR DAILY PROGRESS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3,
                              color: Color(0xFF64806A),
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(green),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        totalTasks == 0
                            ? 'Start by adding your first task ✨'
                            : '$completedTasks of $totalTasks tasks completed. Keep going!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718273),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Statistics
                Row(
                  children: [
                    _buildStat(
                      'Total Tasks',
                      totalTasks.toString(),
                      Icons.task_alt_rounded,
                      const Color(0xFFFFEDCF),
                    ),
                    const SizedBox(width: 12),
                    _buildStat(
                      'Completed',
                      completedTasks.toString(),
                      Icons.check_circle_rounded,
                      const Color(0xFFE2EFDF),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Add task heading
                Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: green,
                      size: 25,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Add task form
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF344B39)
                            .withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Task Title',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF526354),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _titleController,
                          decoration: _inputDecoration(
                            hint: 'What do you need to do?',
                            icon: Icons.edit_rounded,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter task title';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 17),

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF526354),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: _inputDecoration(
                            hint: 'Add a little description...',
                            icon: Icons.notes_rounded,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 17),

                        const Text(
                          'Priority',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF526354),
                          ),
                        ),
                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          decoration: _inputDecoration(
                            hint: 'Choose task priority',
                            icon: Icons.flag_rounded,
                          ),
                          items: ['Low', 'Medium', 'High']
                              .map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _priority = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select priority';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _addTask,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              'Add Task',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // My Tasks heading
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    Text(
                      '$totalTasks tasks',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Empty tasks
                if (tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          size: 45,
                          color: Color(0xFF9BB69D),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks yet!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Add your first task and make today count.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Task cards
                ...tasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;

                  final bool isCompleted =
                      task['completed'] == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _taskColor(index),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 5),

                      leading: Checkbox(
                        value: isCompleted,
                        activeColor: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) {
                          context
                              .read<TaskCubit>()
                              .toggleTask(index);
                        },
                      ),

                      title: Text(
                        task['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? Colors.grey
                              : darkGreen,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),

                          Text(
                            task['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          ),

                          const SizedBox(height: 9),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _priorityColor(
                                task['priority'],
                              ),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                              task['priority'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF596354),
                              ),
                            ),
                          ),
                        ],
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFC77D7D),
                        ),
                        onPressed: () {
                          context
                              .read<TaskCubit>()
                              .deleteTask(index);
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Statistics card
  Widget _buildStat(
    String title,
    String value,
    IconData icon,
    Color cardColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF64806A),
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF344B39),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF718273),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
