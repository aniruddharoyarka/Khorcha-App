import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khorcha/models/transactions.dart';

class RecentTransactionsCard extends StatelessWidget {
  final TransactionModel transaction;

  const RecentTransactionsCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 80,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Color(0xFFF0F5F3), // Subtle light green/grey
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: ListTile(
            leading: Icon(transaction.icon, color: Color(0xFF03624C)),
            title: Text(
              transaction.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            trailing: Text(
              transaction.amount,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: transaction.amount.contains('+') ? Color(0xFF03624C) : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}