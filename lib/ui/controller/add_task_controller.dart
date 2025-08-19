import 'package:get/get.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';

class AddTaskController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask({
    required String title,
    required String description,
    required String status,
  }) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, String> requestBody = {
      "title": title,
      "description": description,
      "status": status,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createNewTaskUrl,
      body: requestBody,
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to add task';
    }
    return isSuccess;
  }
}