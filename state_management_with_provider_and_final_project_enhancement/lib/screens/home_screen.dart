import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_task_screen.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar
            SliverAppBar(
              title: const Text(
                'TaskFlow',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
              floating: true,
              snap: true,
              backgroundColor: colorScheme.background,
              foregroundColor: colorScheme.onBackground,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    // Search functionality
                    showSearch(
                      context: context,
                      delegate: TaskSearchDelegate(
                        taskProvider: Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ),
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Filter functionality
                    _showFilterDialog(context);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.filter_list_rounded,
                      size: 22,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 160),
                child: Column(
                  children: [
                    // Stats Overview
                    Consumer<TaskProvider>(
                      builder: (context, taskProvider, child) {
                        final totalTasks = taskProvider.tasks.length;
                        final completedTasks = taskProvider.tasks
                            .where((t) => t.isCompleted)
                            .length;
                        final pendingTasks = totalTasks - completedTasks;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatCard(
                                context: context,
                                value: totalTasks.toString(),
                                label: 'Total Tasks',
                                color: colorScheme.primary,
                                icon: Icons.task_rounded,
                              ),
                              _buildStatCard(
                                context: context,
                                value: completedTasks.toString(),
                                label: 'Completed',
                                color: Colors.green,
                                icon: Icons.check_circle_rounded,
                              ),
                              _buildStatCard(
                                context: context,
                                value: pendingTasks.toString(),
                                label: 'Pending',
                                color: Colors.orange,
                                icon: Icons.pending_actions_rounded,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: colorScheme.primary,
                        unselectedLabelColor: colorScheme.onSurface.withOpacity(
                          0.6,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Active'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // All Tasks
            _buildTaskList(context, filter: TaskFilter.all),
            // Active Tasks
            _buildTaskList(context, filter: TaskFilter.active),
            // Completed Tasks
            _buildTaskList(context, filter: TaskFilter.completed),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          ).then((_) {
            // Refresh the task list if needed
          });
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTaskList(BuildContext context, {required TaskFilter filter}) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        List<dynamic> filteredTasks;
        switch (filter) {
          case TaskFilter.active:
            filteredTasks = taskProvider.tasks
                .where((task) => !task.isCompleted)
                .toList();
            break;
          case TaskFilter.completed:
            filteredTasks = taskProvider.tasks
                .where((task) => task.isCompleted)
                .toList();
            break;
          default:
            filteredTasks = taskProvider.tasks;
        }

        if (filteredTasks.isEmpty) {
          return _buildEmptyState(context, filter);
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic here
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 80, // Space for FAB
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TaskTile(task: task),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 64) / 3; // dynamic width

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TaskFilter filter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic sizes
    final iconSize = screenWidth * 0.1; // smaller fraction
    final verticalSpacing = screenHeight * 0.02;
    final padding = screenWidth * 0.05;

    String message;
    IconData icon;
    Color color;

    switch (filter) {
      case TaskFilter.active:
        message = 'No active tasks';
        icon = Icons.checklist_rounded;
        color = Colors.green;
        break;
      case TaskFilter.completed:
        message = 'No completed tasks';
        icon = Icons.emoji_events_rounded;
        color = Colors.orange;
        break;
      default:
        message = 'No tasks yet';
        icon = Icons.task_rounded;
        color = colorScheme.primary;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconSize * 0.35),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: color.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Create your first task to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // Add filter options here
              ListTile(
                leading: const Icon(Icons.sort_by_alpha_rounded),
                title: const Text('Sort by name'),
                onTap: () {
                  // Implement sort
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range_rounded),
                title: const Text('Sort by date'),
                onTap: () {
                  // Implement sort
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.priority_high_rounded),
                title: const Text('Sort by priority'),
                onTap: () {
                  // Implement sort
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum TaskFilter { all, active, completed }

// Search delegate for tasks
class TaskSearchDelegate extends SearchDelegate {
  final TaskProvider taskProvider;

  TaskSearchDelegate({required this.taskProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = taskProvider.tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return TaskTile(task: task);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show recent searches or popular tasks
    return Center(
      child: Text(
        'Search for tasks...',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
