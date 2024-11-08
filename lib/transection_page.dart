//view class

import 'package:expences_tracker_with_flutter/financial_tracker.dart';
import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/financial_entry.dart';
import 'package:expences_tracker_with_flutter/financial_entries_list.dart';
import 'package:expences_tracker_with_flutter/financial_entry_card.dart';

class TransectionsPage extends StatefulWidget {
  const TransectionsPage({
    super.key,
    required this.user,
    required this.financialEntries,
    required this.onAddFinancialEntry,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
    required this.themeColor,
  });

  final User user;
  final FinancialEntriesList financialEntries;
  final void Function(FinancialEntry entry) onAddFinancialEntry;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;
  final HSLColor themeColor;

  @override
  State<StatefulWidget> createState() {
    return _TransectionsPageState();
  }
}

class _TransectionsPageState extends State<TransectionsPage> {
  late List<FinancialEntryCard> cards;

  void _addButtonTapped() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context_) {
        return AddFinancialEntry(
          userBalance: widget.user.financialEntries.totalOfIncome(),
          onAddFinancialEntry: widget.onAddFinancialEntry,
          incomeCategoriesList: widget.incomeCategoriesList,
          expenceCategoriesList: widget.expenceCategoriesList,
          themeColor: widget.themeColor,
        );
      },
    );
  }

  void _showTransectionDetails(FinancialEntry currentEntry) {
    showModalBottomSheet(
      context: context,
      builder: (context_) {
        return TransactionDetailView(
          currentEntry: currentEntry,
          themeColor: widget.themeColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of transaction cards from financial entries
    List<Widget> cards = widget.financialEntries.map((financialEntry) {
      return FinancialEntryCard(
        currentExpence: financialEntry,
        showTransactionDetials: _showTransectionDetails,
        themeColor: widget.themeColor,
      );
    }).toList();

    Widget emptyScreenPrompt = Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_circle_outline, size: 40, color: widget.themeColor.toColor()),
        SizedBox(height: 16),
        Text(
          "No transection added yet!",
          style: TextStyle(
            fontSize: 20,
            color: widget.themeColor.toColor(),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Tab the + button to add your first transection.",
          style: TextStyle(
            fontSize: 18,
            color: widget.themeColor.toColor(),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              child: cards.isEmpty
                  ? emptyScreenPrompt
                  : ListView(
                      children: cards,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonTapped,
        backgroundColor: themeColor.adjustedLightness(by: 100), // Vibrant color for visibility
        child: const Icon(
          Icons.add,
          size: 42,
          color: Colors.white,
        ), // New icon and larger size
      ),
    );
  }
}

class AddFinancialEntry extends StatefulWidget {
  const AddFinancialEntry({
    super.key,
    required this.userBalance,
    required this.onAddFinancialEntry,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
    required this.themeColor,
  });

  final double userBalance;
  final void Function(FinancialEntry entry) onAddFinancialEntry;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;
  final HSLColor themeColor;

  @override
  State<StatefulWidget> createState() {
    return _AddFinancialEntryState();
  }
}

class _AddFinancialEntryState extends State<AddFinancialEntry> {
  //flages to validate the user input
  ValidationOptions titleValidator = ValidationOptions.valid;
  ValidationOptions amountValidator = ValidationOptions.valid;
  ValidationOptions detailsValidator = ValidationOptions.valid;
  String amountValidatationText = "";
  bool addButtonDisabled = false;

  String inputTitle = '';
  double inputAmount = 0;
  EntryType inputType = EntryType.income;
  String? inputCategory = "";
  DateTime inputDate = DateTime.now();
  String inputDetails = "";

  List<String> categoryList = [];

  void _titleChanged(String inputValue) {
    setState(() {
      if (inputValue.isEmpty) {
        titleValidator = ValidationOptions.empty;
      } else {
        inputTitle = inputValue;
        titleValidator = ValidationOptions.valid;
      }
    });
  }

  void _amountChanged(String inputValue) {
    setState(() {
      if (inputValue.isEmpty) {
        amountValidator = ValidationOptions.empty;
      } else {
        try {
          inputAmount = double.parse(inputValue);
          if (inputAmount > widget.userBalance) {
            amountValidator = ValidationOptions.notEnoughMoney;
          } else {
            amountValidator = ValidationOptions.valid;
          }
        } catch (exception) {
          amountValidator = ValidationOptions.invalied;
        }
      }
    });
  }

  void _entryTypeChanged(EntryType? inputValue) {
    setState(() {
      inputType = inputValue ?? EntryType.expense;
      categoryList = inputType == EntryType.income
          ? widget.incomeCategoriesList
          : widget.expenceCategoriesList;
    });

    //Resetting the value
    inputCategory = categoryList.isNotEmpty ? categoryList.first : null;
  }

  //selecting category
  void _entryCategoryChanged(String? inputValue) {
    setState(() {
      inputCategory = inputValue ?? "Unknown";
    });
    if (inputCategory == "Unknown") {
      addButtonDisabled = true;
    } else {
      addButtonDisabled = false;
    }
  }

  ///Open date picker to pick new date
  Future<void> _onDatePickerTapped(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: inputDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != inputDate) {
      setState(() {
        inputDate = pickedDate;
      });
    }
  }

  void _detailsChanged(String inputValue) {
    inputDetails = inputValue;
  }

  ///Saving the new Financial Entry
  void _onAddButtonTapped() {
    if (!addButtonDisabled && amountValidatationText == "") {
      widget.onAddFinancialEntry((FinancialEntry(
        title: inputTitle,
        amount: inputAmount,
        type: inputType,
        category: inputCategory ?? "",
        date: inputDate,
        details: inputDetails,
        userId: UsersListManager.selectedUser.id,
      )));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (amountValidator == ValidationOptions.empty) {
      amountValidatationText = "Amount can't be empty";
    } else if (amountValidator == ValidationOptions.notEnoughMoney &&
        inputType == EntryType.expense) {
      amountValidatationText =
          "Can't make transection! Amount more than your balance";
    } else if (amountValidator == ValidationOptions.invalied) {
      amountValidatationText = "Invalid value! Amount Can only be in numbers";
    } else {
      amountValidatationText = "";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Field
          TextField(
            onChanged: _titleChanged,
            maxLength: 40,
            decoration: InputDecoration(
              labelText: "Title for transaction",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between elements
          // Title Validator Message
          if (titleValidator != ValidationOptions.valid)
            Text(
              titleValidator == ValidationOptions.empty
                  ? "Title can't be empty"
                  : "Invalid title",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),

          const SizedBox(height: 16), // Spacing

          // Amount Field
          TextField(
            onChanged: _amountChanged,
            maxLength: 20,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Amount Validator Message
          if (amountValidator != ValidationOptions.valid)
            Text(
              amountValidatationText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),

          const SizedBox(height: 16), // Spacing

          // Dropdowns for Entry Type and Category
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<EntryType>(
                  value: inputType,
                  decoration: InputDecoration(
                    labelText: "Select Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  items: EntryType.values.map((EntryType entry) {
                    return DropdownMenuItem<EntryType>(
                      value: entry,
                      child: Text(entry.name),
                    );
                  }).toList(),
                  onChanged: _entryTypeChanged,
                ),
              ),
              const SizedBox(width: 16), // Space between dropdowns
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: inputCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  items: categoryList.map((String entry) {
                    return DropdownMenuItem<String>(
                      value: entry,
                      child: Text(entry),
                    );
                  }).toList(),
                  onChanged: _entryCategoryChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16), // Spacing

          // Date Picker Button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(inputDate.toPrettyDate()),
                  onPressed: () => _onDatePickerTapped(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16), // Spacing

          // Details Field
          TextField(
            onChanged: _detailsChanged,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: "Some detials of Transaction",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 24), // Spacing

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const 
              SizedBox(width: 16), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor.toColor(),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _onAddButtonTapped,
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum ValidationOptions {
  valid,
  invalied,
  empty,
  negative,
  notEnoughMoney,
}

// extension ToPrettyDateString on DateTime {
//   String toPrettyDate() {
//     List<String> fromMonths = [
//       'Jan', 'Fab', 'Mar', 'Apr',
//       'May', 'Jun', 'Jul', 'Aug',
//       'Sep', 'Oct', 'Nov', 'Dec'
//     ];

//     return "${fromMonths[month - 1]} $day, $year";
//   }
// }

class TransactionDetailView extends StatelessWidget {
  TransactionDetailView({
    required this.currentEntry,
    required this.themeColor,
  });

  final FinancialEntry currentEntry;
  final HSLColor themeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            currentEntry.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '\$${currentEntry.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Type:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                currentEntry.type.name,
                style: TextStyle(
                  fontSize: 18,
                  color: currentEntry.type == EntryType.income
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                currentEntry.category,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                currentEntry.date
                    .toPrettyDate(), //'${currentEntry.date.day}/${currentEntry.date.month}/${currentEntry.date.year}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Details:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            currentEntry.details,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
        ],
      ),
    ); //Padding(padding: const  EdgeInsets.all(12),);
  }
}
