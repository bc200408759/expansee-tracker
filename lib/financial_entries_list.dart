//Model view class

import 'package:expences_tracker_with_flutter/financial_entry.dart';

class FinancialEntriesList {

  FinancialEntriesList({
    required this.financialEntries,
  });

  //to add a entry in list
  void add(FinancialEntry financialEntry) {
    financialEntries.insert(0, financialEntry);
  }
  //get the lenght of the list
  int length() {
    return financialEntries.length;
  }

  void removeAll() {
    financialEntries.clear();
  }

  //custom mam fuction
  List<R> map<R> (R Function(FinancialEntry) transform) {
    List<R> resultList = [];
    for(FinancialEntry financialEntry in financialEntries) {
      resultList.add(transform(financialEntry));
    }
    return resultList;
  }

  //get the totals of the all incomes
  double totalOfIncome() {
    double total = 0;
     for(FinancialEntry financialEntry in financialEntries) {
      if(financialEntry.type == EntryType.income) {
        total += financialEntry.amount;
      }
    } 
    return total;
  }

  //get the totals of the all expences
  double totalOfExpences() {
    double total = 0;
     for(FinancialEntry financialEntry in financialEntries) {
      if(financialEntry.type == EntryType.expense) {
        total += financialEntry.amount;
      }
    } 
    return total;
  }
  
  double getBalance() {
    return totalOfIncome() - totalOfExpences();
  } 


  List<FinancialEntry> financialEntries;
}