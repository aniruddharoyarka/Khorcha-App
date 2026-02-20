import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? note;

  //Subscription
  final bool isSubscription;
  final int? billingCycle; //monthwise
  final DateTime? nextPaymentDate;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
    this.isSubscription = false,
    this.billingCycle,
    this.nextPaymentDate,
  });
  /*
  bool get isExpense => type == TransactionType.expense;


  String get formattedAmount {
    String prefix = type == TransactionType.income ? "+" : "-";
    return "$prefix৳${amount.toStringAsFixed(2)}";

  }
  */
}