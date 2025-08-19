import 'package:get/get.dart';

import '../../../data/service/network_caller.dart';
import '../../../data/urls.dart';

class EmailVerificationController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> verifyEmail({required String email}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyEmailUrl(email.trim()),
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed To Verify Email';
    }

    return isSuccess;
  }
}