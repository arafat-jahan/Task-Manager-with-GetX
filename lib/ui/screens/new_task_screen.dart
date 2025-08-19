import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/new_task_list_controller.dart';
import 'package:getx_taskmanager/ui/controller/task_status_count_controller.dart';
import 'package:getx_taskmanager/ui/screens/add_task_screen.dart';
import 'package:getx_taskmanager/ui/widgets/task_card.dart';
import 'package:getx_taskmanager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NewTaskListController>().getNewTaskList();
      Get.find<TaskStatusCountController>().getTaskStatusCountList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: GetBuilder<TaskStatusCountController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.taskStatusCountList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => TaskSummaryCard(
                          count: controller.taskStatusCountList[i].count,
                          title: controller.taskStatusCountList[i].id,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: GetBuilder<NewTaskListController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ListView.builder(
                        itemCount: controller.newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskType: TaskType.tNew,
                            taskModel: controller.newTaskList[index],
                            onStatusUpdate: () {
                              Get.find<NewTaskListController>()
                                  .getNewTaskList();
                              Get.find<TaskStatusCountController>()
                                  .getTaskStatusCountList();
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onTapAddNewTaskButton() async {
    final result = await Navigator.pushNamed(context, AddTaskScreen.name);
    if (result == true && mounted) {
      Get.find<NewTaskListController>().getNewTaskList();
      Get.find<TaskStatusCountController>().getTaskStatusCountList();
    }
  }
}