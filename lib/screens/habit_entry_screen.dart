import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitgram/constants/icons.dart';
import 'package:habitgram/controller/habit_controller.dart';
import 'package:habitgram/models/habit_model.dart';
import 'package:habitgram/controller/notification_controller.dart';

class HabitEntryScreen extends StatefulWidget {
  @override
  _HabitEntryScreenState createState() => _HabitEntryScreenState();
}

class _HabitEntryScreenState extends State<HabitEntryScreen> {
  final HabitController habitController = Get.put(HabitController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController goalDaysController = TextEditingController();
  TimeOfDay? selectedTime;

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void _addHabit() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final goalDays = int.tryParse(goalDaysController.text);
    final iconIndex = habitController.selectedIconIndex.value;

    if (name.isEmpty || description.isEmpty || goalDays == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final newHabit = Habit(
      name: name,
      description: description,
      goalDays: goalDays,
      iconIndex: iconIndex,
    );
    habitController.addHabit(newHabit);

    final currentTime = DateTime.now();
    final selectedTimeDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final isAllowed = await NotificationController.requestNotificationPermission();
    if (isAllowed) {
      NotificationController.scheduleHabitNotification(
        habitName: newHabit.name,
        date: selectedTimeDateTime,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 16.0),
              TextField(
                controller: goalDaysController,
                decoration: const InputDecoration(
                  labelText: 'Goal Days',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Text(
                          selectedTime != null ? formatTimeOfDay(selectedTime!) : 'Select Time',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('Select an Icon:'),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: iconsDefault.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      habitController.selectIcon(index);
                    },
                    child: Obx(() {
                      final selectedIconIndex = habitController.selectedIconIndex.value;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedIconIndex == index ? Colors.blue : Colors.transparent,
                          ),
                        ),
                        child: Icon(iconsDefault[index]),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addHabit,
                child: const Text('Add Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
