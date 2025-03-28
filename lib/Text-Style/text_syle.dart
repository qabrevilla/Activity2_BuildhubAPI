import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle navTextStyle(bool isSelected) {
    return GoogleFonts.dmSans(
      color: isSelected ? const Color.fromRGBO(157, 0, 1, 1.0) : Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }
}
