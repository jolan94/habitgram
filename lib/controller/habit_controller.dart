import 'package:get/get.dart';
import 'package:habitgram/models/habit_model.dart';
import 'package:habitgram/services/local_storage_service.dart';

class HabitController extends GetxController {
  final RxList<Habit> habits = <Habit>[].obs;
  final RxInt selectedIconIndex = RxInt(-1);
  // final Rx<Habit> selectedHabit = Habit(
  //   name: '',
  //   description: '',
  //   goalDays: 0,
  //   iconIndex: 0,
  //   completed: false,
  // ).obs;
  final Rx<Habit?> selectedHabit = Rx<Habit?>(null);
  final LocalStorageService localStorage = Get.put(LocalStorageService());

  @override
  void onInit() {
    super.onInit();
    final List<dynamic>? habitList = localStorage.read('habits');
    if (habitList != null) {
      habits.assignAll(habitList.map((habit) => Habit.fromJson(habit)).toList());
    }
  }

  void addHabit(Habit habit) {
    habits.add(habit);
    saveHabitsToStorage();
  }

  void updateHabit(Habit habit) {
    final index = habits.indexWhere((element) => element.name == selectedHabit.value?.name);
    if (index != -1) {
      habits[index] = habit;
      saveHabitsToStorage();
    }
  }

  void deleteHabit() {
    final habit = selectedHabit.value;
    if (habit != null) {
      habits.removeWhere((element) => element.name == habit.name);
      saveHabitsToStorage();
    }
  }

  void selectHabit(Habit habit) {
    selectedHabit.value = habit;
  }

  void toggleHabitCompletion(int index) {
    final habit = habits[index];
    habit.completed = !habit.completed;
    habits[index] = habit; // Update the habit in the list
    saveHabitsToStorage();
  }

  void selectIcon(int index) {
    selectedIconIndex.value = index;
  }

  void saveHabitsToStorage() {
    localStorage.write('habits', habits.toList());
  }
}
