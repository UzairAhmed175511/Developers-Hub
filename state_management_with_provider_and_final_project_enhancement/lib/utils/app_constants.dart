import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.blue;
  static const background = Colors.white;
  static const taskDone = Colors.green;
  static const delete = Colors.red;
}

class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyles {
  static const TextStyle taskTitle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle taskTitleDone = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
