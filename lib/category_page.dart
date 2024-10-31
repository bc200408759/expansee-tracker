//view class

import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/financial_entry.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.onAddCategory,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
  });

  final void Function(EntryType categoryFor, String categoryName) onAddCategory;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;
  @override
  State<StatefulWidget> createState() {
    return _CatregoriesPageState();
  }
}

class _CatregoriesPageState extends State<CategoriesPage> {
  EntryType selectedType = EntryType.income;

  List<Widget> categoriesWidgetList = [];

  void _onIcomeButtonTapped() {
    setState(() {
      selectedType = EntryType.income;
    });
  }

  void _onExpenceButtonTapped() {
    setState(() {
      selectedType = EntryType.expense;
    });
  }

  void _addButtonTapped() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context_) {
        return AddCategory(onAddCategory: widget.onAddCategory,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categoriesList = selectedType == EntryType.income
        ? widget.incomeCategoriesList
        : widget.expenceCategoriesList;
    categoriesWidgetList.clear();

    for (String category in categoriesList) {
      categoriesWidgetList.add(Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.fromLTRB(16, 2, 16, 2),
        color: const Color.fromARGB(193, 216, 134, 212),
        child: Row(
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
      ));
    }

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
        Row(
          children: [
            TextButton(
              onPressed: _onIcomeButtonTapped,
              child: const Text("Income"),
            ),
            TextButton(
              onPressed: _onExpenceButtonTapped,
              child: const Text("Expences"),
            ),
          ],
        ),
        Column(
          children: categoriesWidgetList,
        )
      ],
    );
  }
}



class AddCategory extends StatefulWidget {
  const AddCategory({super.key, required this.onAddCategory});

  final void Function(EntryType categoryFor, String categoryName) onAddCategory;

  @override
  State<StatefulWidget> createState() {
    return _AddCategoryState();
  }
}

class _AddCategoryState extends State<AddCategory> {
  bool validInput = true;
  EntryType inputType = EntryType.income;
  String categoryName = '';

  void _onEntryTypeChanged(EntryType? inputValue) {
    setState(() {
      inputType = inputValue ?? EntryType.expense;
    });
  }

  void _onCategoryNameChanged(String inputValue) {
    setState(() {
      validInput = inputValue.isNotEmpty;
      categoryName = inputValue; // Always set categoryName
    });
  }

  void _onAddButtonTapped() {
    if (validInput) {
      widget.onAddCategory(inputType, categoryName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 72, 12, 0),
      child: Column(
        children: [
          DropdownButton<EntryType>(
            value: inputType,
            hint: const Text("Select Type"),
            icon: const Icon(Icons.arrow_downward),
            items: EntryType.values.map<DropdownMenuItem<EntryType>>((EntryType entry) {
              return DropdownMenuItem<EntryType>(
                value: entry,
                child: Text(entry.name),
              );
            }).toList(),
            onChanged: _onEntryTypeChanged,
          ),
          TextField(
            onChanged: _onCategoryNameChanged,
            maxLength: 20,
            decoration: const InputDecoration(label: Text("New Category name")),
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
                ),
              ),
              Expanded(
                child: TextButton(
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