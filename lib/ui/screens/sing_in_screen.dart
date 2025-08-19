
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_taskmanager/ui/controller/sing_in_controller.dart';
import 'package:getx_taskmanager/ui/screens/home_screen.dart';
import 'package:getx_taskmanager/ui/screens/sing_up_screen.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';
import '../widgets/screen_background.dart';
import 'Forgot Password Screens/email_verification_screen.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  static const String name = '/sing-in';

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final SingInController _singInController = Get.find<SingInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Form(
              key: _fromKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 170),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      String email = value ?? '';
                      if (EmailValidator.validate(email) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 0) {
                        return 'Enter a valid Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<SingInController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.inProgress == false,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                          onPressed: _onTapSingInButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sing Up',
                                style: TextStyle(
                                  color: Color(0xFF21bf73),
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSingUpButton,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _onTapSingUpButton() {
    Navigator.pushReplacementNamed(context, SingUpScreen.name);
  }

  void _onTapForgotPasswordButton() {
    Navigator.pushReplacementNamed(context, EmailVerificationScreen.name);
  }

  void _onTapSingInButton() {
    if (_fromKey.currentState!.validate()) {
      _singIn();
    }
  }

  Future<void> _singIn() async {
    final bool isSuccess = await _singInController.singIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (isSuccess) {
      Get.offAllNamed(HomeScreen.name);
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, _singInController.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
