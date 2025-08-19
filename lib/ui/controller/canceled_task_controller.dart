import 'package:get/get.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';

class CanceledTaskController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;
  List<TaskModel> _canceledTaskList = [];

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get canceledTaskList => _canceledTaskList;

  Future<bool> getCanceledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getCancelledTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];

      for (Map<String, dynamic> item in response.body!['data']) {
        list.add(TaskModel.formJson(item));
      }
      _canceledTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}