import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitgram/controller/habit_controller.dart';
import 'package:habitgram/models/habit_model.dart';

class HabitEditScreen extends StatelessWidget {
  final HabitController habitController = Get.put(HabitController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController goalDaysController = TextEditingController();

  HabitEditScreen({super.key, required Habit habit}) {
    nameController.text = habit.name;
    descriptionController.text = habit.description;
    goalDaysController.text = habit.goalDays.toString();

    habitController.selectHabit(habit);
    habitController.selectIcon(habit.iconIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: goalDaysController,
              decoration: const InputDecoration(
                labelText: 'Goal Days',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final description = descriptionController.text;
                final goalDays = int.parse(goalDaysController.text);
                final updatedHabit = Habit(
                  name: name,
                  description: description,
                  goalDays: goalDays,
                  iconIndex: habitController.selectedIconIndex.value,
                  completed: habitController.selectedHabit.value!.completed,
                );
                habitController.updateHabit(updatedHabit);
                Get.back();
              },
              child: const Text('Update Habit'),
            ),
            ElevatedButton(
              onPressed: () {
                habitController.deleteHabit();
                Get.back();
              },
              child: const Text('Delete Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
