import 'package:flutter/material.dart';
import 'package:expences_tracker_with_flutter/user.dart';

// import 'package:expences_tracker_with_flutter/transection_page.dart';
// import 'package:expences_tracker_with_flutter/balance_page.dart';
// import 'package:expences_tracker_with_flutter/category_page.dart';
// import 'package:expences_tracker_with_flutter/users_page.dart';
// import 'package:expences_tracker_with_flutter/financial_entry.dart';
import 'package:expences_tracker_with_flutter/financial_tracker.dart';
 
class HomeScreenLayout extends StatefulWidget {
  const HomeScreenLayout({
    super.key,
    required this.usersList,
    required this.buildPages,
    required this.switchUser,
    required this.themeColor,s
  });

  final UsersListManager usersList;
  final List<Widget> Function() buildPages;
  final Function(String id) switchUser;
  final HSLColor themeColor;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenLayoutState();
  }
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  @override
  void initState() {
    super.initState();
    // initilizing the database
    FinancialTracker.refresh = _refresh;
    widget.switchUser('7336a624-69f6-4d79-834e-458017de2318');
  }

  // Keeps track of selected page
  int _selectedPageIndex = 0;

  // This function is executed when any of the page buttons from
  // the AppBar are tapped, changing the tapped page index
  // to the selected one
  void _onPageButtonTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _refresh() {
    setState(() {
      _selectedPageIndex = _selectedPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = widget.buildPages();
    final Widget currentPage = pages[_selectedPageIndex];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Expense Tracker",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            floating: true,
            expandedHeight: 72,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.themeColor.toColor(), widget.themeColor.toColor(),],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: currentPage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        onTap: _onPageButtonTapped,
        selectedItemColor: widget.themeColor.toColor(),
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(
          color: widget.themeColor.toColor(), // Selected icon color
          size: 30, // Selected icon size
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey, // Unselected icon color
          size: 24, // Unselected icon size
        ),
        selectedLabelStyle: TextStyle(
          color: widget.themeColor.toColor(),
          fontWeight: FontWeight.bold
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: "Balance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Users",
          ),
        ],
      ),
    );
  }
}
