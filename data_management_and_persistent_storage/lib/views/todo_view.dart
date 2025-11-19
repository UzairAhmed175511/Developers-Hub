import 'package:data_management_and_persistent_storage/view_models/todo_viewmodel.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoViewModel viewModel = TodoViewModel();
  final TextEditingController controller = TextEditingController();
  final TextEditingController editController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    viewModel.loadTasks().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // Header with task count
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tasks",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${viewModel.tasks.length}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.task_alt_rounded,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),

          // Add task section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: _editingIndex == null
                        ? "What needs to be done?"
                        : "Editing task...",
                    labelStyle: TextStyle(
                      color: _editingIndex == null
                          ? Colors.grey[600]
                          : Colors.orange,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _editingIndex == null
                        ? Colors.grey[100]
                        : Colors.orange.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: _editingIndex == null
                                  ? Colors.grey[500]
                                  : Colors.orange,
                            ),
                            onPressed: () {
                              controller.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) =>
                      _editingIndex == null ? _addTask() : _updateTask(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_editingIndex != null) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _cancelEdit(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: _editingIndex == null ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: controller.text.trim().isNotEmpty
                            ? (_editingIndex == null ? _addTask : _updateTask)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _editingIndex == null
                              ? Colors.deepPurple
                              : Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _editingIndex == null ? Icons.add : Icons.save,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _editingIndex == null
                                  ? "Add Task"
                                  : "Update Task",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tasks list
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: viewModel.tasks.isEmpty
                  ? _buildEmptyState()
                  : _buildTasksList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Text(
          "No tasks yet",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Add a task to get started!",
          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildTasksList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            children: [
              Text(
                "Your Tasks",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Text(
                "${viewModel.tasks.length} items",
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskItem(viewModel.tasks[index], index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(String task, int index) {
    return Dismissible(
      key: Key('$task-$index'),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _removeTask(index);
        } else {
          _startEditing(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: index < viewModel.tasks.length - 1
              ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
              : null,
        ),
        child: ListTile(
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _editingIndex == index
                    ? Colors.orange
                    : Colors.deepPurple.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check,
              color: _editingIndex == index ? Colors.orange : Colors.deepPurple,
              size: 16,
            ),
          ),
          title: Text(
            task,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _editingIndex == index ? Colors.orange : Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: _editingIndex == index ? Colors.orange : Colors.blue,
                ),
                onPressed: () => _startEditing(index),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: _editingIndex == index
                      ? Colors.orange
                      : Colors.grey[400],
                ),
                onPressed: () => _removeTask(index),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      controller.text = viewModel.tasks[index];
      focusNode.requestFocus();
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      controller.clear();
      focusNode.unfocus();
    });
  }

  void _updateTask() {
    if (controller.text.trim().isNotEmpty && _editingIndex != null) {
      setState(() {
        viewModel.updateTask(_editingIndex!, controller.text.trim());
        _editingIndex = null;
      });
      controller.clear();
      focusNode.unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Task updated successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _addTask() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        viewModel.addTask(controller.text.trim());
      });
      controller.clear();
      focusNode.unfocus();
    }
  }

  void _removeTask(int index) {
    setState(() {
      viewModel.removeTask(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task removed"),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.white,
          onPressed: () {
            // Note: You'd need to implement undo functionality in your ViewModel
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    editController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
