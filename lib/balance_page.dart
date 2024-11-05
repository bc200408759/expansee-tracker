//view class

import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/financial_entries_list.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key, required this.financialEntriesList});

  final FinancialEntriesList financialEntriesList;

  @override
  State<StatefulWidget> createState() {
    return _BalancePageState();
  }
}

class _BalancePageState extends State<BalancePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[850],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceRow(
              "Income",
              widget.financialEntriesList.totalOfIncome().toString(),
              Colors.green,
              Icons.attach_money),
          const SizedBox(height: 16), // Spacing between rows
          _buildBalanceRow(
              "Expense",
              widget.financialEntriesList.totalOfExpences().toString(),
              Colors.red,
              Icons.money_off),
          const SizedBox(height: 16), // Spacing between rows
          _buildBalanceRow(
              "Balance",
              widget.financialEntriesList.getBalance().toString(),
              Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              Icons.account_balance),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(
      String label, String amount, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              "$label: ",
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
