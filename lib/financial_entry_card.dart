//View class

import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/financial_entry.dart';




class FinancialEntryCard extends StatelessWidget {
  const FinancialEntryCard({super.key, required this.currentExpence});

  final FinancialEntry currentExpence;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
        color: const Color.fromARGB(197, 226, 184, 208),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_rounded),
          const SizedBox(width: 16),
          Column(
            children: [
              Text(
                currentExpence.category,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              Text(
                currentExpence.date.toPrettyDate(),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                "\$ ${currentExpence.amount}",
                style: TextStyle(
                    color: currentExpence.type == EntryType.income? Colors.green: Colors.red,
                    fontSize: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension ToPrettyDateString on DateTime {
 String toPrettyDate() {
  List<String> fromMonths = [
    'Jan', 'Fab', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug',
    'Sep', 'Oct', 'Nov', 'Dec'
  ];

  return "${fromMonths[month - 1]} $day, $year";
 }
}


// class ExpenceCart extends StatefulWidget {
//   const ExpenceCart({super.key, required this.currentExpence});

//   final Expence currentExpence;

//   @override
//   State<StatefulWidget> createState() {
//     return _ExpensesCartState();
//   }
// }

// class _ExpensesCartState extends State<ExpenceCart> {
  
//   _ExpensesCartState() {
//     category = widget.currentExpence.category.toString();
//     amount = widget.currentExpence.amount;
//     title = widget.currentExpence.title;
//     date = widget.currentExpence.date.toString();

//   }
     
//     late String category;
//     late double amount;
//     late String title;
//     late String date;


//   @override
//   Widget build(BuildContext context) {
    
 
//     return Row(
//       children: [
//         const Icon(Icons.shopping_bag_rounded),
//         Text(category),
//       ],
//     );
//   }
// }
