//view class

import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/financial_entry.dart';
import 'package:expences_tracker_with_flutter/financial_entries_list.dart';
import 'package:expences_tracker_with_flutter/financial_entry_card.dart';

class TransectionsPage extends StatefulWidget {
  const TransectionsPage({
    super.key,
    required this.financialEntries,
    required this.onAddFinancialEntry,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
  });

  //List if expences
  final FinancialEntriesList financialEntries;
  final void Function(FinancialEntry entry) onAddFinancialEntry;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;


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
          onAddFinancialEntry: widget.onAddFinancialEntry,
          incomeCategoriesList: widget.incomeCategoriesList,
          expenceCategoriesList: widget.expenceCategoriesList,  
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    cards = widget.financialEntries.map((financialEntry) {
      return FinancialEntryCard(currentExpence: financialEntry);
    }).toList();

    
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _addButtonTapped,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        Column(
          children: cards,
        )
      ],
    );
  }
}


class AddFinancialEntry extends StatefulWidget {
  const AddFinancialEntry({
    super.key,
    required this.onAddFinancialEntry,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
  });

  final void Function(FinancialEntry entry) onAddFinancialEntry;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;


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
          amountValidator = ValidationOptions.valid;
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
    if (addButtonDisabled == false) {
      widget.onAddFinancialEntry((FinancialEntry(
          title: inputTitle,
          amount: inputAmount,
          type: inputType,
          category: inputCategory ?? "",
          date: inputDate,
          details: inputDetails,
          userId: UsersListManager.selectedUser.id,
        )
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 32, 12, 0),
      child: Column(
        children: [
          TextField(
            onChanged: _titleChanged,
            maxLength: 40,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          Text(
            titleValidator == ValidationOptions.valid
                ? ""
                : titleValidator == ValidationOptions.empty
                    ? "Title can't be empty"
                    : titleValidator == ValidationOptions.invalied
                        ? "Invalid title"
                        : "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
          TextField(
            onChanged: _amountChanged,
            maxLength: 20,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(label: Text("Amount")),
          ),
          Text(
            amountValidator == ValidationOptions.valid
                ? ""
                : amountValidator == ValidationOptions.empty
                    ? "Amount can't be empty"
                    : amountValidator == ValidationOptions.invalied
                        ? "Invalid amount"
                        : "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButton(
                  value: inputType,
                  hint: const Text("Select Type"),
                  icon: const Icon(Icons.arrow_downward),
                  items: EntryType.values
                      .map<DropdownMenuItem<EntryType>>((EntryType entry) {
                    return DropdownMenuItem<EntryType>(
                      value: entry,
                      child: Text(entry.name),
                    );
                  }).toList(),
                  onChanged: _entryTypeChanged,
                ),
              ),
              Expanded(
                flex: 3,
                child: DropdownButton(
                  value: inputCategory,
                  hint: const Text("Select Category"),
                  icon: const Icon(Icons.arrow_downward),
                  items: categoryList
                      .map<DropdownMenuItem<String>>((String entry) {
                    return DropdownMenuItem<String>(
                      value: entry,
                      child: Text(entry.toString()),
                    );
                  }).toList(),
                  onChanged: _entryCategoryChanged,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextButton(
                  child: Text(inputDate.toPrettyDate()),
                  onPressed: () => _onDatePickerTapped(context),
                ),
              ),
            ],
          ),
          TextField(
            onChanged: _detailsChanged,
            maxLength: 200,
            decoration: const InputDecoration(label: Text("Detials")),
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Expanded(
                child: TextButton(
                    onPressed: _onAddButtonTapped, child: const Text("Add")),
              )
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
