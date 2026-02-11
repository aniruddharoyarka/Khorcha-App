import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.icon,
    this.iconColor = const Color(0xFF03624C),
  });
}