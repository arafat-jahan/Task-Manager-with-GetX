import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:getx_taskmanager/data/models/task_model.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';

import '../../data/service/network_caller.dart';
import '../../data/urls.dart';

enum TaskType { tNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  final TaskModel taskModel;
  final TaskType taskType;
  final VoidCallback onStatusUpdate;

  const TaskCard({
    super.key,
    required this.taskModel,
    required this.taskType,
    required this.onStatusUpdate,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.black45),
            ),
            Text(
              "Date: ${widget.taskModel.createdDate}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: _getTaskChipColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Spacer(),
                Builder(
                  builder: (ctx) {
                    return IconButton(
                      onPressed: () {
                        _showEditTaskStatusPopover(ctx);
                      },
                      icon: Icon(
                        Icons.edit_calendar,
                        color: Colors.greenAccent,
                      ),
                    );
                  },
                ),
                Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          _showDeleteConfrimationPopover(context);
                        },
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                      );
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskChipColor() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return Colors.lightBlueAccent;
      case TaskType.progress:
        return Colors.purpleAccent;
      case TaskType.completed:
        return Colors.green;
      case TaskType.cancelled:
        return Colors.red;
    }
  }

  String _getTaskTypeName() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return 'New';
      case TaskType.progress:
        return 'Progress';
      case TaskType.completed:
        return 'Completed';
      case TaskType.cancelled:
        return 'Cancelled';
    }
  }

  void _showEditTaskStatusPopover(BuildContext ctx) {
    showPopover(
      context: ctx,
      bodyBuilder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusOption('New', TaskType.tNew),
          _statusOption('In Progress', TaskType.progress),
          _statusOption('Completed', TaskType.completed),
          _statusOption('Cancelled', TaskType.cancelled),
        ],
      ),
      direction: PopoverDirection.bottom,
      width: 200,
      height: 230,
      arrowHeight: 10,
      arrowWidth: 20,
      backgroundColor: const Color(0xFF21BF73),
      barrierColor: Colors.transparent,
    );
  }

  void _showDeleteConfrimationPopover(BuildContext ctx) {
    showPopover(
      context: ctx,
      bodyBuilder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Are you sure you want to delete this task?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteTask();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      direction: PopoverDirection.bottom,
      width: 250,
      height: 120,
      arrowHeight: 10,
      arrowWidth: 20,
      backgroundColor: const Color(0xFF21BF73),
      barrierColor: Colors.transparent,
    );
  }

  Widget _statusOption(String label, TaskType type) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      trailing: _getTaskStatusTrailing(type),
      onTap: () {
        if (widget.taskType == type) return;
        _updateTaskStatus(label);
      },
    );
  }

  Widget? _getTaskStatusTrailing(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  Future<void> _updateTaskStatus(String status) async {
    Navigator.pop(context);
    _updateTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );

    _updateTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, response.errorMessage!);
      }
    }
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );

    _deleteTaskInProgress = false;
    if (mounted) setState(() {});

    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else {
      if (mounted) {
        ShowSnackBarMessage(
          context,
          response.errorMessage ?? 'Failed to delete task.',
        );
      }
    }
  }
}