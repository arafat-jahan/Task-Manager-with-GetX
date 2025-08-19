import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getx_taskmanager/ui/screens/sing_in_screen.dart';
import 'package:getx_taskmanager/ui/utils/assets_path.dart';

import '../controller/auth_controller.dart';
import '../widgets/screen_background.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    bool isLoggedIn = await AuthController.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreen.name);
    } else {
      Navigator.pushReplacementNamed(context, SingInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(child: SvgPicture.asset(AssetPaths.logoSvg)),
      ),
    );
  }
}