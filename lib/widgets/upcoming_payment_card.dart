import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class UpcomingPaymentCard extends StatelessWidget {
  final TransactionModel payment; // Changed to TransactionModel

  const UpcomingPaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTransactionDetails(context, payment),
        child: Container(
          width: 180,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFF03624C), // Use a theme color
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.calendar_month, color: Color(0xFF03624C), size: 25),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      payment.title,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "৳${payment.amount.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
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