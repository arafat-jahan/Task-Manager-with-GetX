import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:getx_taskmanager/data/service/network_caller.dart';
import 'package:getx_taskmanager/data/urls.dart';
import 'package:getx_taskmanager/ui/screens/sing_in_screen.dart';
import 'package:getx_taskmanager/ui/widgets/screen_background.dart';

import '../widgets/snack_bar_message.dart';
import 'home_screen.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  static const String name = '/sing-up';

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _singUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Form(
              key: _globalKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 170),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String email = value ?? '';
                      if (EmailValidator.validate(email) == false) {
                        return 'Enter a Valid Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _mobileTEController,
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
                  const SizedBox(height: 15),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return 'Enter a valid Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _singUpInProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapSingUp,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Have account? ',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sing In',
                            style: TextStyle(
                              color: Color(0xFF21bf73),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSingInButton,
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

  void _onTapSingInButton() {
    Navigator.pushReplacementNamed(context, SingInScreen.name);
  }

  void _onTapSingUp() {
    if (_globalKey.currentState!.validate()) {
      _singUp();
    }
  }

  Future<void> _singUp() async {
    _singUpInProgress = true;
    setState(() {});

    Map<String, String> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    _singUpInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      clearTextFields();
      ShowSnackBarMessage(
        context,
        "Registration has been success. Please login",
      );
    } else {
      ShowSnackBarMessage(context, response.errorMessage!);
    }
  }

  void clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _mobileTEController.dispose();
    _lastNameTEController.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _passwordTEController.dispose();
  }
}