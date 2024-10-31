//model class
import 'package:uuid/uuid.dart';

const Uuid idObject = Uuid();

class FinancialEntry {
  FinancialEntry({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.details,
    required this.userId,
  }): id = idObject.v6();

  FinancialEntry.loadEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.details,
    required this.userId,
  });

  final String title;
  final double amount;
  final DateTime date;
  final String details;
  final String category;
  final EntryType type;
  String id;
  String userId;

//For database interection
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category,
      'date': date.toIso8601String(),
      'details': details,
      'userId': userId,
    };
  }

  factory FinancialEntry.fromMap(Map<String, dynamic> map) {
    return FinancialEntry.loadEntry (
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'] == 'income' ? EntryType.income : EntryType.expense,
      category: map['category'],
      date: DateTime.parse(map['date'] as String),
      details: map['details'],
      userId: map['userId'],
    );
  }

}


enum EntryType {
  income,
  expense
}
