import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/progress_task_controller.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProgressTaskController>().getProgressTaskList();
    });
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
                child: GetBuilder<ProgressTaskController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ListView.builder(
                        itemCount: controller.progressTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskType: TaskType.progress,
                            taskModel: controller.progressTaskList[index],
                            onStatusUpdate: () {
                              Get.find<ProgressTaskController>()
                                  .getProgressTaskList();
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