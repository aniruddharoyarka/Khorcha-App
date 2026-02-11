import 'package:flutter/material.dart';

class UpcomingPaymentModel {
  final String title;
  final String amount;
  final IconData icon;
  final Color themeColor;

  UpcomingPaymentModel({
    required this.title,
    required this.amount,
    required this.icon,
    this.themeColor = const Color(0xFF03624C),
  });
}