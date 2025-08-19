import 'package:get/get.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';

class TaskStatusCountController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  List<TaskStatusCountModel> _taskStatusCountList = [];

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;

  Future<bool> getTaskStatusCountList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getTasksStatusCountUrl,
    );

    if (response.isSuccess && response.body != null) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> item in response.body!['data'] ?? []) {
        list.add(TaskStatusCountModel.fromJson(item));
      }
      _taskStatusCountList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to load task status counts';
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}