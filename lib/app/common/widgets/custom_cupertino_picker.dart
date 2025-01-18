import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

class CustomCupertinoPicker extends StatelessWidget {
  final FixedExtentScrollController scrollController;
  final List<Widget> children;
  final Function(int) onSelectedItemChanged;

  CustomCupertinoPicker({
    required this.scrollController,
    required this.children,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      child: CupertinoPicker(
        itemExtent: 45,
        magnification: 1.22,
        looping: true,
        useMagnifier: true,
        scrollController: scrollController,
        children: children,
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: AppColors.highlight.withOpacity(0.3),
        ),
        onSelectedItemChanged: onSelectedItemChanged,
      ),
    );
  }
}
