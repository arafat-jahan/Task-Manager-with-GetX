import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_taskmanager/controller_binders.dart';
import 'package:getx_taskmanager/ui/screens/add_task_screen.dart';
import 'package:getx_taskmanager/ui/screens/Forgot%20Password%20Screens/email_verification_screen.dart';
import 'package:getx_taskmanager/ui/screens/Forgot%20Password%20Screens/pin_verification_screen.dart';
import 'package:getx_taskmanager/ui/screens/Forgot%20Password%20Screens/set_password_screen.dart';
import 'package:getx_taskmanager/ui/screens/home_screen.dart';
import 'package:getx_taskmanager/ui/screens/sing_in_screen.dart';
import 'package:getx_taskmanager/ui/screens/sing_up_screen.dart';
import 'package:getx_taskmanager/ui/screens/splash_screen.dart';
import 'package:getx_taskmanager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: const Color(0xFF21bf73),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: SplashScreen.name,
      getPages: [
        GetPage(name: SplashScreen.name, page: () => const SplashScreen()),
        GetPage(name: SingInScreen.name, page: () => const SingInScreen()),
        GetPage(name: SingUpScreen.name, page: () => const SingUpScreen()),
        GetPage(name: HomeScreen.name, page: () => const HomeScreen()),
        GetPage(
          name: EmailVerificationScreen.name,
          page: () => const EmailVerificationScreen(),
        ),
        GetPage(name: AddTaskScreen.name, page: () => const AddTaskScreen()),
        GetPage(
          name: UpdateProfileScreen.name,
          page: () => const UpdateProfileScreen(),
        ),
        GetPage(
          name: PinVerificationScreen.name,
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            if (args == null || !args.containsKey('email')) {
              return const PinVerificationScreen(email: '');
            }
            return PinVerificationScreen(email: args['email'] as String);
          },
        ),
        GetPage(
          name: SetPasswordScreen.name,
          page: () => const SetPasswordScreen(),
        ),
      ],
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const SplashScreen(),
      ),
      initialBinding: ControllerBinders(),
    );
  }
}