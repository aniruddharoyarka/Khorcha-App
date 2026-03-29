import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class RecentTransactionsCard extends StatelessWidget {
  final TransactionModel transaction;

  const RecentTransactionsCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color amountColor = transaction.type == TransactionType.income
        ? const Color(0xFF03624C)
        : Colors.red;

    final String sign = transaction.type == TransactionType.income ? "+" : "-";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _showTransactionDetails(context, transaction),
        child: Container(
          height: 80,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Color(0xFFF0F5F3),
              borderRadius: BorderRadius.circular(15)
          ),
          child: Center(
            child: ListTile(
              leading: Icon(Icons.receipt_long, color: Color(0xFF03624C)),
              title: Text(
                transaction.title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              trailing: Text(
                "$sign৳${transaction.amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: amountColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showTransactionDetails(BuildContext context, TransactionModel tx) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
            SizedBox(height: 20),
            Text(tx.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(tx.category, style: TextStyle(color: Colors.grey[600])),
            Divider(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount", style: TextStyle(fontSize: 16)),
                Text(
                  "${tx.type == TransactionType.income ? '+' : '-'} ৳${tx.amount}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: tx.type == TransactionType.income ? Color(0xFF03624C) : Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date", style: TextStyle(fontSize: 16)),
                Text("${tx.date.day}/${tx.date.month}/${tx.date.year}"),
              ],
            ),

            if (tx.isSubscription) ...[
              SizedBox(height: 10),
              Chip(label: Text("Subscription"), backgroundColor: Color(0x2203624C)),
            ],

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  print("Deleting transaction: ${tx.id}");
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Transaction deleted"), backgroundColor: Colors.red),
                  );
                },
                icon: Icon(Icons.delete_outline, color: Colors.white),
                label: Text("Delete Transaction", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}