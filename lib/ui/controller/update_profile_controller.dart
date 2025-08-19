import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    Uint8List? imageBytes,
  }) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, String> requestBody = {
      "email": email,
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "mobile": mobile.trim(),
    };

    if (password != null && password.isNotEmpty) {
      requestBody['password'] = password.trim();
    }

    if (imageBytes != null) {
      String base64Image = base64Encode(imageBytes);
      requestBody['photo'] = base64Image;
    }

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    _inProgress = false;
    update();

    if (response.isSuccess) {
      String? photoBase64;
      if (imageBytes != null) {
        photoBase64 = base64Encode(imageBytes);
      }

      Get.find<AuthController>().updateUserProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        mobile: mobile.trim(),
        photo: photoBase64,
      );

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to update profile';
    }

    return isSuccess;
  }
}