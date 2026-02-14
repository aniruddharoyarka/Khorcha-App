import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class RecentTransactionsCard extends StatelessWidget {
  final TransactionModel transaction;

  const RecentTransactionsCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Determine color based on the Enum type
    final Color amountColor = transaction.type == TransactionType.income
        ? const Color(0xFF03624C)
        : Colors.red;

    // Determine the sign (+ or -)
    final String sign = transaction.type == TransactionType.income ? "+" : "-";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFF0F5F3),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: ListTile(
            // Use a default icon if you haven't added specific icons to the new model yet
            leading: Icon(Icons.receipt_long, color: const Color(0xFF03624C)),
            title: Text(
              transaction.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            trailing: Text(
              "$sign৳${transaction.amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: amountColor, // Now uses the logic above
              ),
            ),
          ),
        ),
      ),
    );
  }
}