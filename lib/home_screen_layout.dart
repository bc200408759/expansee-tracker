
import 'package:flutter/material.dart';
import 'package:expences_tracker_with_flutter/user.dart';

// import 'package:expences_tracker_with_flutter/transection_page.dart';
// import 'package:expences_tracker_with_flutter/balance_page.dart';
// import 'package:expences_tracker_with_flutter/category_page.dart';
// import 'package:expences_tracker_with_flutter/users_page.dart';
// import 'package:expences_tracker_with_flutter/financial_entry.dart';
import 'package:expences_tracker_with_flutter/financial_tracker.dart';



class HomeScreenLayout extends StatefulWidget{
  const HomeScreenLayout({
    super.key,
    required this.usersList,
    required this.buildPages,
    required this.switchUser,
  
  });
  
  final UsersListManager usersList;
  final List<Widget> Function() buildPages;
  final Function(String id) switchUser;

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
    print("UI refreshed-------------");
  }
  

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = widget.buildPages();
    final Widget currentPage = pages[_selectedPageIndex];

    print("Home Screen Layout rebuild");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Expence Tracker"),
            floating: true,
            expandedHeight: 102,
            actions: [
              IconButton(
                icon: const Icon(Icons.tag_faces_sharp),
                onPressed: () => _onPageButtonTapped(0),
              ),
              IconButton(
                icon: const Icon(Icons.list_outlined),
                onPressed: () => _onPageButtonTapped(1),
              ),
              IconButton(
                icon: const Icon(Icons.category_outlined),
                onPressed: () => _onPageButtonTapped(2),
              ),
              IconButton(
                icon: const Icon(Icons.people_outline),
                onPressed: () => _onPageButtonTapped(3),
              ),
            ],
          ),
          SliverToBoxAdapter(child: currentPage),
        ],
      ),
    );
  }
}