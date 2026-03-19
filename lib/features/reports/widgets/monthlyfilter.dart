import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../transaction/viewmodels/transaction_provider.dart';

class MonthFilterBar extends StatefulWidget {
  const MonthFilterBar({super.key, required this.onMonthChanged});

  final Function(DateTime) onMonthChanged;
  @override
  State<MonthFilterBar> createState() => _MonthFilterBarState();
}

class _MonthFilterBarState extends State<MonthFilterBar> {

  int selectedMonth = DateTime.now().month;

  final List<String> monthNames = [
    "January","February","March","April","May","June",
    "July","August","September","October","November","December"
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>()
          .getTransactionsByMonth(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedMonth,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: List.generate(12, (index) {

            int monthNumber = index + 1;

            return DropdownMenuItem(
              value: monthNumber,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(width: 8),
                  Text(monthNames[index]),
                ],
              ),
            );

          }),

          onChanged: (value) {

            setState(() {
              selectedMonth = value!;
            });

            context.read<TransactionProvider>()
                .getTransactionsByMonth(value!);
          },
        ),
      ),
    );
  }
}