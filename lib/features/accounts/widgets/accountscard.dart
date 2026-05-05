import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';

import '../../../core/appscolors.dart';
import '../../uihelper.dart';

class AccountsCard extends StatelessWidget {
  final String accountName;
  final String holderName;
  final String accountNumber;
  final double balance;

  const AccountsCard({
    super.key,
    required this.accountName,
    required this.holderName,
    required this.accountNumber,
    required this.balance,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const Color(0xFF1E1E1E);
    }
    final List<Color> colors = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFF1F8E9), // Light Green
      const Color(0xFFFFF8E1), // Light Amber
      const Color(0xFFF3E5F5), // Light Purple
      const Color(0xFFFCE4EC), // Light Pink
      const Color(0xFFE0F2F1), // Light Teal
      const Color(0xFFEFEBE9), // Light Brown
    ];
    // Use hashcode of accountName to pick a stable "random" color
    return colors[accountName.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currency = settingsProvider.currency;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = _getBackgroundColor(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppsColors.primary.withOpacity(0.3), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        uiHelper.CustomText(
                          text: accountName,
                          fontSize: 18,
                          fontweight: FontWeight.bold,
                          context: context,
                        ),
                        uiHelper.CustomText(
                          text: holderName,
                          fontSize: 16,
                          fontweight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black54,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.account_balance, size: 24.r, color: AppsColors.primary),
                      uiHelper.CustomText(
                        text: accountNumber,
                        fontSize: 14,
                        fontweight: FontWeight.bold,
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              /// Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  uiHelper.CustomText(
                    text: "Current Balance",
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                    context: context,
                  ),
                  uiHelper.CustomText(
                    text: "${balance.toStringAsFixed(2)} $currency",
                    fontSize: 24,
                    fontweight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontfamily: "bold",
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
