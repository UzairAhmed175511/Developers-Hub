import 'package:shared_preferences/shared_preferences.dart';

class CounterViewModel {
  int counter = 0;

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
  }

  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', counter);
  }

  void increment() {
    counter++;
    saveCounter();
  }

  void decrement() {
    counter--;
    saveCounter();
  }

  void reset() {
    counter = 0;
    saveCounter();
  }
}
