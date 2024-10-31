//view controller

import 'package:flutter/material.dart';

// import 'package:expences_tracker_with_flutter/datebase_controller.dart';
import 'package:expences_tracker_with_flutter/splash_screen.dart';
import 'package:expences_tracker_with_flutter/home_screen_layout.dart';
import 'package:expences_tracker_with_flutter/transection_page.dart';
import 'package:expences_tracker_with_flutter/balance_page.dart';
import 'package:expences_tracker_with_flutter/category_page.dart';
import 'package:expences_tracker_with_flutter/users_page.dart';
import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/financial_entry.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

class FinancialTracker extends StatefulWidget {
  const FinancialTracker({super.key});

  static void Function() refresh = () {};

  @override
  State<StatefulWidget> createState() {
    return _FinancialTrackerState();
  }
}

class _FinancialTrackerState extends State<FinancialTracker> {
  //visible screen for user
  Widget visibleScreen = const SplashScreen();

  final UsersListManager _userList = UsersListManager();

  User _user = User(name: "Mohib");

  @override
  void initState() {
    super.initState();
    // initilizing the database
    _initilizeDatabase();
  
    FinancialTracker.refresh();
  }

  Future<void> _initilizeDatabase() async {
    // wait for the database to initilize
    final result = _userList.initDatabase();
    if (result == false) {
      print("Unable to load the database");
    }
    setState(() {
      visibleScreen = HomeScreenLayout(
        usersList: _userList,
        buildPages: _buildPages,
      );
    });
  }

  //User related functions start
  void _switchUser(String id) {
    _userList.switchUser(id);
    _user = UsersListManager.selectedUser;
    FinancialTracker.refresh();
  }

  void _onAddUser(String name) {
    _userList.addUser(
      User(name: name),
    );
    FinancialTracker.refresh();
  }

  void _onChangeUserName(String id, String newName) {
    _userList.changeUserNameforId(
      id,
      newName,
    );
    FinancialTracker.refresh();
  }

  void _deleteUser(String id) {
    _userList.deleteUserWithId(
      id,
    );
    FinancialTracker.refresh();
  }

  //Add new financial entry
  void _addFinancialEntry(FinancialEntry entry) {
    _userList.addFinancialEntry(entry);
    FinancialTracker.refresh();
  }

  //Add new type of category in list of financial cetegories
  void _addCategory(EntryType categoryFor, String categoryName) {
    _userList.addCategory(categoryFor, categoryName);
    FinancialTracker.refresh();
  }

  List<Widget> _buildPages() {
    return [
      TransectionsPage(
        financialEntries: _user.financialEntries,
        onAddFinancialEntry: _addFinancialEntry,
        incomeCategoriesList: User.incomeCategories,
        expenceCategoriesList: User.expenceCategories,
      ),
      BalancePage(financialEntriesList: _user.financialEntries),
      CategoriesPage(
        onAddCategory: _addCategory,
        incomeCategoriesList: User.incomeCategories,
        expenceCategoriesList: User.expenceCategories,
      ),
      UsersPage(
        usersList: _userList,
        selectedUserId: UsersListManager.selectedUser.id,
        onAddUser: _onAddUser,
        onChangeUserName: _onChangeUserName,
        onSwitchUser: _switchUser,
        onDeleteUser: _deleteUser,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return visibleScreen;
  }
}
