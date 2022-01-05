import 'package:currency_converter_app/ui/app_colors.dart';
import 'package:flutter/material.dart';

class TitleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -30,
      left: -30,
      child: SizedBox(
        width: 300,
        height: 200,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.background2,
          ),
        ),
      ),
    );
  }
}
