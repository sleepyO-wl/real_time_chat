import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('chat');
  }

  Future<void> saveMessage(String message) async {
    final box = Hive.box('chat');
    await box.add(message);
  }

  List<String> getMessages() {
    final box = Hive.box('chat');
    return box.values.cast<String>().toList();
  }
}
