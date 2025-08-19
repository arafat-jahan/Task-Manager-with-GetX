import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'auth_controller.dart';

class SingInController extends GetxController {
  bool _inInProgress = false;

  String? _errorMessage;

  bool get inProgress => _inInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> singIn(String email, String password) async {
    bool isSuccess = false;
    _inInProgress = true;
    update();

    Map<String, String> requestBody = {"email": email, "password": password};

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
      isFromLogin: true,
    );

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(response.body!['data']);
      String token = response.body!['token'];

      await AuthController.saveUserData(userModel, token);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inInProgress = false;
    update();

    return isSuccess;
  }
}