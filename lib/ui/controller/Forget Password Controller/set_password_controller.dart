import 'package:get/get.dart';
import '../../../data/service/network_caller.dart';
import '../../../data/urls.dart';

class SetPasswordController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, String> requestBody = {
      'email': email.trim(),
      'OTP': otp.trim(),
      'password': password.trim(),
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Password reset failed';
    }

    return isSuccess;
  }
}