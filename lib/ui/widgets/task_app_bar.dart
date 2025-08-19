import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getx_taskmanager/ui/controller/auth_controller.dart';

import '../screens/sing_in_screen.dart';
import '../screens/update_profile_screen.dart';

class TaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TaskAppBar> createState() => _TaskAppBarState();
}

class _TaskAppBarState extends State<TaskAppBar> {
  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: const Color(0xFF21BF73),

      leading: canPop
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      )
          : null,
      leadingWidth: canPop ? 40 : 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: _onTapProfile,
              child: CircleAvatar(
                radius: 24,
                backgroundImage:
                (AuthController.userModel?.photo == null ||
                    AuthController.userModel!.photo!.isEmpty)
                    ? null
                    : MemoryImage(
                  base64Decode(AuthController.userModel!.photo!),
                ),
                backgroundColor: Colors.grey[400],
                child:
                (AuthController.userModel?.photo == null ||
                    AuthController.userModel!.photo!.isEmpty)
                    ? Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AuthController.userModel?.fullName ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AuthController.userModel?.email ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.white,
          onPressed: _onTapSignOutButton,
        ),
      ],
    );
  }

  Future<void> _onTapSignOutButton() async {
    await AuthController.removeUserData();
    Navigator.pushNamedAndRemoveUntil(context, SingInScreen.name, (_) => false);
  }

  void _onTapProfile() {
    if (ModalRoute.of(context)!.settings.name != UpdateProfileScreen.name) {
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }
  }
}