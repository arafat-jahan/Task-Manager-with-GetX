import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:getx_taskmanager/ui/controller/Forget%20Password%20Controller/pin_verification_controller.dart';
import 'package:getx_taskmanager/ui/screens/Forgot%20Password%20Screens/set_password_screen.dart';
import 'package:getx_taskmanager/ui/widgets/screen_background.dart';
import 'package:getx_taskmanager/ui/widgets/snack_bar_message.dart';
import '../sing_in_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  final String email;

  const PinVerificationScreen({super.key, required this.email});

  static const String name = '/pin-verification';

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final PinVerificationController _pinVerificationController = Get.find<PinVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 170),
                Text(
                  'PIN Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification pin has been sent to your email address',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    selectedColor: Colors.green,
                    inactiveColor: Colors.grey,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  controller: _otpTEController,
                  appContext: context,
                ),
                const SizedBox(height: 16),
                GetBuilder<PinVerificationController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: const Text('Verify'),
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
                          recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
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
    );
  }

  void _onTapSignInButton() {
    Get.offAllNamed(SingInScreen.name);
  }

  void _onTapSubmitButton() {
    if (_otpTEController.text.length == 6) {
      _verifyOtp();
    } else {
      ShowSnackBarMessage(context, 'Enter a 6 digit OTP');
    }
  }

  Future<void> _verifyOtp() async {
    final bool isSuccess = await _pinVerificationController.verifyOtp(
      email: widget.email,
      otp: _otpTEController.text.trim(),
    );

    if (isSuccess) {
      print('Navigating to SetPasswordScreen with args: ${{
        'email': widget.email,
        'otp': _otpTEController.text.trim(),
      }}');
      Get.offNamed(
        SetPasswordScreen.name,
        arguments: {
          'email': widget.email,
          'otp': _otpTEController.text.trim(),
        },
      );
    } else {
      if (mounted) {
        ShowSnackBarMessage(context, _pinVerificationController.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}