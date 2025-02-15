//View class

import 'package:expences_tracker_with_flutter/extensions.dart';
import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/financial_entry.dart';

class FinancialEntryCard extends StatelessWidget {
  const FinancialEntryCard({
    super.key,
    required this.currentExpence,
    required this.showTransactionDetials,
    required this.themeColor,
  });

  final FinancialEntry currentExpence;
  final Function(FinancialEntry) showTransactionDetials;
  final HSLColor themeColor;

  void showDetials() {
    showTransactionDetials(currentExpence);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: themeColor.adjustLightness(130).toColor(),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with color based on type (income or expense)
          Icon(
            currentExpence.type == EntryType.income
                ? Icons.trending_up // Icon for income
                : Icons.trending_down, // Icon for expense
            color: Colors.black,
            size: 30,
          ),
          const SizedBox(width: 16),

          // Column for category, date, and amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row: category and date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentExpence.category,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      currentExpence.date.toPrettyDate(),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),

                // Amount aligned to the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: showDetials,
                      icon: Icon(
                        Icons.arrow_drop_down_circle_sharp,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "\$${currentExpence.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: currentExpence.type == EntryType.income
                            ? Colors.green
                            : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension ToPrettyDateString on DateTime {
  String toPrettyDate() {
    List<String> fromMonths = [
      'Jan',
      'Fab',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return "${fromMonths[month - 1]} $day, $year";
  }
}

