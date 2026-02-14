import 'package:flutter/material.dart';

// Using an enum makes your code less "buggy" than using plain Strings for types
enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? note;

  // --- Subscription Logic ---
  final bool isSubscription;
  final int? billingCycle; // e.g., 1 for monthly, 12 for yearly
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

  // Helper method to check if a transaction is an expense
  bool get isExpense => type == TransactionType.expense;

  // Helper to format the amount for the UI
  String get formattedAmount {
    String prefix = type == TransactionType.income ? "+" : "-";
    return "$prefix৳${amount.toStringAsFixed(2)}";
  }
}