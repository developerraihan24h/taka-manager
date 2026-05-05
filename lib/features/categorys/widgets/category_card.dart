import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.transactionCount,
    required this.totalAmount,
  });

  final String categoryName;
  final int transactionCount;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currency = settingsProvider.currency;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : .05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25,
            child: Icon(Icons.wallet),
          ),
          title: Text(
            categoryName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("$transactionCount transactions"),
          trailing: Text(
            "$totalAmount $currency",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
