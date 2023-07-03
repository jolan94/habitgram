import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  final box = GetStorage();

  T? read<T>(String key) {
    return box.read<T>(key);
  }

  void write<T>(String key, T value) {
    box.write(key, value);
  }

  void delete(String key) {
    box.remove(key);
  }
}
