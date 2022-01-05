import 'package:currency_converter_app/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subtitle extends StatelessWidget {
  final double fontSize;
  final String text;

  const Subtitle({required this.fontSize, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: GoogleFonts.josefinSans(
        color: AppColors.button,
        fontSize: this.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
