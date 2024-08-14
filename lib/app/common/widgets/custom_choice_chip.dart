import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  CustomChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool isSelected) {
        onSelected();
      },
      labelStyle: CustomTextStyle.semiBold(14, color: isSelected ? AppColors.white : AppColors.black),
      backgroundColor: Colors.transparent,
      selectedColor: Color(0xFF34C2C1),
      showCheckmark: false,
    );
  }
}
