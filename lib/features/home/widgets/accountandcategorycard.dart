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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: isSelected
            ? AppsColors.primary.withOpacity(0.3) // selected background
            : (isDark ? Colors.grey.shade900 : AppsColors.bottomBattonBackground),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppsColors.primary
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
              radius: 18.r,
              child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: uiHelper.customImage(imgurl: "taka.png"),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              accountName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.white : Colors.black87,
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