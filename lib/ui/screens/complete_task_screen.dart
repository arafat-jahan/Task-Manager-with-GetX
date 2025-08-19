import 'package:flutter/material.dart';
import 'package:getx_taskmanager/data/models/task_model.dart';
import 'package:getx_taskmanager/data/service/network_caller.dart';
import 'package:getx_taskmanager/data/urls.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/complete_task_controller.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CompleteTaskController>().getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<CompleteTaskController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ListView.builder(
                        itemCount: controller.completedTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskType: TaskType.completed,
                            taskModel: controller.completedTaskList[index],
                            onStatusUpdate: () {
                              Get.find<CompleteTaskController>()
                                  .getCompletedTaskList();
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
    );
  }
}