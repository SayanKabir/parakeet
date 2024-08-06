import 'package:flutter/material.dart';
import 'package:parakeet/theming/colors.dart';

class MyThemes {
  static ThemeData MyLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade500,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey.shade800,
          displayColor: Colors.black,
        ),
  );
  static ThemeData MyDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: color03,
    ),
    // textTheme: ThemeData.dark().textTheme.apply(
    //       bodyColor: Colors.grey.shade300,
    //       displayColor: Colors.white,
    //     ),
  );
}
