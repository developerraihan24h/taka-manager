import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppsColors.bottomBattonBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppsColors.primary, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

              /// Top Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      uiHelper.CustomText(
                        text: accountName,
                        fontSize: 18,
                        fontweight: FontWeight.bold,
                      ),
                      uiHelper.CustomText(
                        text: holderName,
                        fontSize: 16,
                        fontweight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Icon(Icons.account_balance),
                      uiHelper.CustomText(
                        text: accountNumber,
                        fontSize: 14,
                        fontweight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),

              /// Balance
              Row(
                children: [
                  uiHelper.CustomText(
                    text: balance.toString(),
                    fontSize: 24,
                    fontweight: FontWeight.bold,
                    color: Colors.black54,
                    fontfamily: "bold",
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