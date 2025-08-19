import 'package:flutter/material.dart';

import '../widgets/task_app_bar.dart';
import 'canceled_task_list.dart';
import 'complete_task_screen.dart';
import 'progress_task_screen.dart';
import 'new_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompleteTaskScreen(),
    CanceledTaskList(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "New"),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outlined),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel_outlined),
            label: "Canceled",
          ),
        ],
        selectedItemColor: Color.fromRGBO(33, 191, 115, 1),
        unselectedItemColor: Color.fromRGBO(135, 142, 150, 1.0),
        currentIndex: _selectedIndex,
        onTap: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}