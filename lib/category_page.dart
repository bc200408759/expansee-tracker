//view class

import 'package:flutter/material.dart';

import 'package:expences_tracker_with_flutter/financial_entry.dart';
import 'package:expences_tracker_with_flutter/extensions.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.onAddCategory,
    required this.incomeCategoriesList,
    required this.expenceCategoriesList,
    required this.themeColor,
  });

  final void Function(EntryType categoryFor, String categoryName) onAddCategory;
  final List<String> incomeCategoriesList;
  final List<String> expenceCategoriesList;
  final HSLColor themeColor;

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
        return AddCategory(
          onAddCategory: widget.onAddCategory,
        );
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
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.themeColor.adjustLightness(80).toColor(), widget.themeColor.adjustLightness(130).toColor(), ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income and Expense Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _onIcomeButtonTapped,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == EntryType.income
                      ? Colors.green
                      : Colors.grey, // Highlighting selected type
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Income",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: _onExpenceButtonTapped,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == EntryType.expense
                      ? Colors.red
                      : Colors.grey, // Highlighting selected type
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Expense",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),

          const SizedBox(
              height: 16), // Spacing between button row and category list

          // Category List
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return categoriesWidgetList.isNotEmpty
                          ? categoriesWidgetList[index]
                          : const Center(child: Text('No categories available'));
                    },
                    childCount: categoriesWidgetList.length,
                  ),
                ),
              ],
            ),
          ),

          // Add Button at the bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _addButtonTapped,
              backgroundColor: widget.themeColor.adjustLightness(40).toColor(), // Vibrant color for visibility
              child: const Icon(
                Icons.add,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 72.0, 16.0, 16.0),

      height: MediaQuery.of(context)
          .size
          .height, // Fill the entire height of the screen
      child: SingleChildScrollView(
        // Allows for scrolling if the keyboard appears
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Add New Category",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Dropdown for Entry Type
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<EntryType>(
                value: inputType,
                hint: const Text("Select Type"),
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true, // Expands the dropdown to fit the container
                underline: const SizedBox(), // Remove the underline
                items: EntryType.values
                    .map<DropdownMenuItem<EntryType>>((EntryType entry) {
                  return DropdownMenuItem<EntryType>(
                    value: entry,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(entry.name),
                    ),
                  );
                }).toList(),
                onChanged: _onEntryTypeChanged,
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Text Field for Category Name
            TextField(
              onChanged: _onCategoryNameChanged,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: "New Category Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color.fromRGBO(232, 159, 243, 1)),
                ),
                hintText: "Enter category name",
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10), // Spacing between buttons
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
      ),
    );
  }
}
