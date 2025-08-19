import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/ui/controller/Forget%20Password%20Controller/set_password_controller.dart';
import 'package:getx_taskmanager/ui/screens/sing_in_screen.dart';
import 'package:getx_taskmanager/ui/widgets/screen_background.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  static const String name = '/set-password';

  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
  TextEditingController();
  final SetPasswordController _setPasswordController =
  Get.find<SetPasswordController>();
  late final String email;
  late final String otp;

  @override
  void initState() {
    super.initState();
    print(
      'SetPasswordScreen received args: $Get.arguments, type: ${Get.arguments.runtimeType}',
    );
    final dynamic args = Get.arguments;
    if (args is Map<String, dynamic>) {
      email = args['email'] ?? '';
      otp = args['otp'] ?? '';
    } else if (args is String) {
      email = args;
      otp = '';
    } else {
      email = '';
      otp = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 170),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum length password 6 characters with letter and number combination',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Re-enter the password';
                      }
                      if (value != _passwordTEController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<SetPasswordController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapConfirmButton,
                          child: const Text('Confirm'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Have account? ',
                        style: const TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: Color(0xFF21bf73),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Get.offAllNamed(SingInScreen.name);
  }

  void _onTapConfirmButton() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    if (email.isEmpty || otp.isEmpty) {
      if (mounted) {
        ShowSnackBarMessage(context, 'Invalid email or OTP');
      }
      return;
    }
    final bool isSuccess = await _setPasswordController.resetPassword(
      email: email,
      otp: otp,
      password: _passwordTEController.text.trim(),
    );

    if (isSuccess) {
      if (mounted) {
        ShowSnackBarMessage(
          context,
          'Password reset successful. Please sign in.',
        );
        Get.offAllNamed(SingInScreen.name);
      }
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, _setPasswordController.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}