import 'package:cloud_firestore/cloud_firestore.dart';
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
  final double guiltValue;

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
    required this.guiltValue,
    this.note,
    this.isSubscription = false,
    this.billingCycle,
    this.nextPaymentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'type': type.name,
      'note': note,
      'guiltValue': guiltValue,
      'isSubscription': isSubscription,
      'billingCycle': billingCycle,
      'nextPaymentDate': nextPaymentDate,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? '',
      type: TransactionType.values.firstWhere(
            (e) => e.name == data['type'],
      ),
      guiltValue: (data['guiltValue'] as num).toDouble(),
      note: data['note'],
      isSubscription: data['isSubscription'] ?? false,
      billingCycle: data['billingCycle'],
      nextPaymentDate: data['nextPaymentDate'] != null
          ? (data['nextPaymentDate'] as Timestamp).toDate()
          : null,
    );
  }


  /*
  bool get isExpense => type == TransactionType.expense;


  String get formattedAmount {
    String prefix = type == TransactionType.income ? "+" : "-";
    return "$prefix৳${amount.toStringAsFixed(2)}";

  }
  */
}