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
    return Column(
      children: [
        Row(
          children: [
          const Text(
            "Income: ",
            style: TextStyle(
              color: Colors.green,
              fontSize: 24,
            ),
          ),
          Text(
            "${widget.financialEntriesList.totalOfIncome()}",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 24,
            ),
          )
        ]),
        Row(
          children: [
          const Text(
            "Expence: ",
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
            ),
          ),
          Text(
            "${widget.financialEntriesList.totalOfExpences()}",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 24,
            ),
          )
        ]),
        Row(
          children: [
          Text(
            "Balance: ",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 24,
            ),
          ),
          Text(
            "${widget.financialEntriesList.getBalance()}",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,

              fontSize: 24,
            ),
          )
        ])
      ],
    );
  }
}
