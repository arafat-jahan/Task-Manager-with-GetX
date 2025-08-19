import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getx_taskmanager/data/models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  UserModel? _userModel;
  String? _accessToken;

  UserModel? get currentUserModel => _userModel;

  String? get currentAccessToken => _accessToken;

  static UserModel? get userModel => instance._userModel;

  static String? get accessToken => instance._accessToken;

  Future<void> saveUserDataInstance(UserModel model, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('user-data', jsonEncode(model.toJson()));
    await sharedPreferences.setString('token', token);

    _userModel = model;
    _accessToken = token;
    update();
  }

  Future<void> getUserDataInstance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userData = sharedPreferences.getString('user-data');
    if (userData != null) {
      _userModel = UserModel.fromJson(jsonDecode(userData));
      _accessToken = sharedPreferences.getString('token');
      update();
    }
  }

  Future<bool> isUserLoggedInInstance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token != null) {
      await getUserDataInstance();
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeUserDataInstance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
    _accessToken = null;
    _userModel = null;
    update();
  }

  void updateUserProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? photo,
  }) {
    if (_userModel != null) {
      _userModel!.firstName = firstName;
      _userModel!.lastName = lastName;
      _userModel!.mobile = mobile;
      if (photo != null) {
        _userModel!.photo = photo;
      }

      _saveUpdatedUserData();
      update();
    }
  }

  Future<void> _saveUpdatedUserData() async {
    if (_userModel != null && _accessToken != null) {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      await sharedPreferences.setString(
        'user-data',
        jsonEncode(_userModel!.toJson()),
      );
    }
  }

  static Future<void> saveUserData(UserModel model, String token) async {
    await instance.saveUserDataInstance(model, token);
  }

  static Future<void> getUserData() async {
    await instance.getUserDataInstance();
  }

  static Future<bool> isUserLoggedIn() async {
    return await instance.isUserLoggedInInstance();
  }

  static Future<void> removeUserData() async {
    await instance.removeUserDataInstance();
  }
}