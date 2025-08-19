import 'package:flutter/material.dart';
import 'package:getx_taskmanager/ui/controller/add_task_controller.dart';
import 'package:getx_taskmanager/ui/widgets/screen_background.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';
import 'package:getx_taskmanager/ui/widgets/task_app_bar.dart';
import 'package:get/get.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  static const String name = '/add-new-task';

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AddTaskController _addTaskController = Get.find<AddTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      body: SafeArea(
        child: ScreenBackground(
          child: Form(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Subject'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 10,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<AddTaskController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.inProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapSubmitButton,
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_globalKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    final bool isSuccess = await _addTaskController.addNewTask(
      title: _titleTEController.text,
      description: _descriptionTEController.text,
      status: 'New',
    );

    if (isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        ShowSnackBarMessage(context, 'Task Added Successfully');
        Get.back(result: true);
      }
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, _addTaskController.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}