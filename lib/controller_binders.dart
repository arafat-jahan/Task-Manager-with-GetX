import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/Forget%20Password%20Controller/email_verification_controller.dart';
import 'package:getx_taskmanager/ui/controller/Forget%20Password%20Controller/pin_verification_controller.dart';
import 'package:getx_taskmanager/ui/controller/Forget%20Password%20Controller/set_password_controller.dart';
import 'package:getx_taskmanager/ui/controller/add_task_controller.dart';
import 'package:getx_taskmanager/ui/controller/auth_controller.dart';
import 'package:getx_taskmanager/ui/controller/canceled_task_controller.dart';
import 'package:getx_taskmanager/ui/controller/complete_task_controller.dart';
import 'package:getx_taskmanager/ui/controller/new_task_list_controller.dart';
import 'package:getx_taskmanager/ui/controller/progress_task_controller.dart';
import 'package:getx_taskmanager/ui/controller/sing_in_controller.dart';
import 'package:getx_taskmanager/ui/controller/task_status_count_controller.dart';
import 'package:getx_taskmanager/ui/controller/update_profile_controller.dart';

class ControllerBinders extends Bindings {
  @override
  void dependencies() {
    Get.put(SingInController());
    Get.put(NewTaskListController());
    Get.put(TaskStatusCountController());
    Get.put(ProgressTaskController());
    Get.put(CompleteTaskController());
    Get.put(CanceledTaskController());
    Get.put(UpdateProfileController());
    Get.put(AuthController());
    Get.put(AddTaskController());
    Get.put(EmailVerificationController());
    Get.put(PinVerificationController());
    Get.put(SetPasswordController());
  }
}