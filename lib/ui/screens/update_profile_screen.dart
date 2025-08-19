import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getx_taskmanager/ui/controller/auth_controller.dart';
import 'package:getx_taskmanager/ui/controller/update_profile_controller.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';
import '../widgets/screen_background.dart';
import '../widgets/task_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = "/update-profile";

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  final UpdateProfileController _updateProfileController =
  Get.find<UpdateProfileController>();

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userModel?.email ?? '';
    _firstNameTEController.text = AuthController.userModel?.firstName ?? '';
    _lastNameTEController.text = AuthController.userModel?.lastName ?? '';
    _phoneTEController.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      body: SafeArea(
        child: ScreenBackground(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailTEController,
                    enabled: false,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneTEController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Mobile Number';
                      }
                      if (value.length != 11) {
                        return 'Enter a Valid Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      int length = value?.length ?? 0;
                      if (length > 0 && length <= 6) {
                        return 'Enter a password more than 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<UpdateProfileController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapUpdatedButton,
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _onTapImagePicker,
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _selectedImage == null ? "Select Image" : _selectedImage!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapImagePicker() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }

  Future<void> _onTapUpdatedButton() async {
    if (_globalKey.currentState!.validate()) {
      await _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileController.updateProfile(
      email: _emailTEController.text,
      firstName: _firstNameTEController.text,
      lastName: _lastNameTEController.text,
      mobile: _phoneTEController.text,
      password: _passwordTEController.text.isNotEmpty
          ? _passwordTEController.text
          : null,
      imageBytes: _selectedImage != null
          ? await _selectedImage!.readAsBytes()
          : null,
    );

    if (isSuccess) {
      _passwordTEController.clear();
      if (mounted) {
        ShowSnackBarMessage(context, 'Profile updated successfully');
      }
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, _updateProfileController.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}