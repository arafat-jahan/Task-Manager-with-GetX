import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/canceled_task_controller.dart';
import '../widgets/task_card.dart';

class CanceledTaskList extends StatefulWidget {
  const CanceledTaskList({super.key});

  @override
  State<CanceledTaskList> createState() => _CanceledTaskListState();
}

class _CanceledTaskListState extends State<CanceledTaskList> {
  @override
  void initState() {
    super.initState();
    Get.find<CanceledTaskController>().getCanceledTaskList();
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
                child: GetBuilder<CanceledTaskController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ListView.builder(
                        itemCount: controller.canceledTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskType: TaskType.cancelled,
                            taskModel: controller.canceledTaskList[index],
                            onStatusUpdate: () {
                              Get.find<CanceledTaskController>()
                                  .getCanceledTaskList();
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
