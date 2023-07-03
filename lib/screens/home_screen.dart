import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitgram/constants/icons.dart';
import 'package:habitgram/controller/habit_controller.dart';
import 'package:habitgram/screens/habit_entry_screen.dart';
import 'package:habitgram/screens/habit_edit_screen.dart';
import 'package:habitgram/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final HabitController habitController = Get.put(HabitController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const ProfileScreen());
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: habitController.habits.length,
          itemBuilder: (context, index) {
            final habit = habitController.habits[index];
            return ListTile(
              leading: Icon(iconsDefault[habit.iconIndex]), // Replace with actual icon based on iconIndex
              title: Text(habit.name),
              subtitle: Text(habit.description),
              trailing: IconButton(
                icon: Icon(habit.completed ? Icons.check_box : Icons.check_box_outline_blank),
                onPressed: () {
                  habitController.toggleHabitCompletion(index);
                },
              ),
              onTap: () {
                Get.to(HabitEditScreen(habit: habit)); // Navigate to Habit Edit Screen
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(HabitEntryScreen()); // Navigate to Habit Entry Screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
