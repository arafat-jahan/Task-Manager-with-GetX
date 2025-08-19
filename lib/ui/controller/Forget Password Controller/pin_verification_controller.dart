
import 'package:get/get.dart';
import '../../../data/service/network_caller.dart';
import '../../../data/urls.dart';

class PinVerificationController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> verifyOtp({required String email, required String otp}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyOtpUrl(email.trim(), otp.trim()),
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'OTP Verification Failed';
    }

    return isSuccess;
  }
}
