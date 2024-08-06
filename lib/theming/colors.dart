import 'package:flutter/material.dart';

final color1 = Color(0xffbbd48a);
final color2 = Color(0xff89c47a);
final color3 = Color(0xff56a787);


final color01 = Color(0xffeeefed);
final color02 = Color(0xff608467);
final color03 = Color(0xff36725c);
final color04 = Color(0xffa5bf90);
final color05 = Color(0xffafd2c5);
final color06 = Color(0xff85b538);
final color07 = Color(0xff4f4a50);
final color08 = Color(0xff75bb7d);
final color09 = Color(0xffbed883);

final myColor_lightGreen = Color(0xFF91C98F); // Light green
final myColor_teal = Color(0xFF2BB2A8); // Teal
final myColor_darkTeal = Color(0xFF0585A1); // Darker teal
final myColor_gray = Color(0xFF444A5A); // Gray

// Light mode gradient
final LinearGradient lightGradient = LinearGradient(
  colors: [
    Color(0xFF43C6AC), // Light green
    Color(0xFF66D1A6), // Medium green
    Color(0xFF2BB673), // Darker green
    Color(0xFF191654), // Blue-purple
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Dark mode gradient
final LinearGradient darkGradient = LinearGradient(
  colors: [
    Color(0xFF0F2027), // Darker blue
    Color(0xFF2C5364), // Blue
    Color(0xFF4E4376), // Purple
    Color(0xFF2BB673), // Green
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
