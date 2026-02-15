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
      child: InkWell(
        onTap: () => _showTransactionDetails(context, transaction),
        borderRadius: BorderRadius.circular(15),
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
      ),
    );
  }
}

void _showTransactionDetails(BuildContext context, TransactionModel tx) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Sheet only takes needed space
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(tx.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(tx.category, style: TextStyle(color: Colors.grey[600])),
            const Divider(height: 30),

            // Amount and Date Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount", style: TextStyle(fontSize: 16)),
                Text(
                  "${tx.type == TransactionType.income ? '+' : '-'} ৳${tx.amount}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: tx.type == TransactionType.income ? const Color(0xFF03624C) : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date", style: TextStyle(fontSize: 16)),
                Text("${tx.date.day}/${tx.date.month}/${tx.date.year}"),
              ],
            ),

            if (tx.isSubscription) ...[
              const SizedBox(height: 10),
              const Chip(label: Text("Subscription"), backgroundColor: Color(0x2203624C)),
            ],

            const SizedBox(height: 30),

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logic to delete will go here (connect to your database later)
                  print("Deleting transaction: ${tx.id}");
                  Navigator.pop(context); // Close sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transaction deleted"), backgroundColor: Colors.red),
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label: const Text("Delete Transaction", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}