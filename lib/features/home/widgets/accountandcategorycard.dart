import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/appscolors.dart';
import '../../uihelper.dart';

class AccountAndCategoryCard extends StatelessWidget {
  final String accountName;
  final bool isSelected;

  const AccountAndCategoryCard({
    super.key,
    required this.accountName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: isSelected
            ? AppsColors.primary.withOpacity(0.2) // selected background
            : AppsColors.bottomBattonBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppsColors.primary
              : Colors.grey,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22.r,
              child: SizedBox(
                height: 25.h,
                width: 25.w,
                child: uiHelper.customImage(imgurl: "taka.png"),
              ),
            ),
            SizedBox(height: 5),
            Text(
              accountName,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}