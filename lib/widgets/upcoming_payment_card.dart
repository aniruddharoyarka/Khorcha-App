import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

import '../services/firestore_service.dart';

class UpcomingPaymentCard extends StatelessWidget {
  final TransactionModel payment;

  const UpcomingPaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _showTransactionDetails(context, payment),
        child: Container(
          width: 180,
          margin:  EdgeInsets.only(right: 10),
          padding:  EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFF03624C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.calendar_month, color: Color(0xFF03624C), size: 25),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      payment.title,
                      style:  TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "৳${payment.amount.toStringAsFixed(0)}",
                      style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "Due on: ${payment.nextPaymentDate!.day}/${payment.nextPaymentDate!.month}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            const SizedBox(height: 20),
            Text(tx.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(tx.category, style: TextStyle(color: Colors.grey[600])),
            const Divider(height: 30),

            // Amount Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount", style: TextStyle(fontSize: 16)),
                Text(
                  "${tx.type == TransactionType.income ? '+' : '-'} ৳${tx.amount}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tx.type == TransactionType.income ? const Color(0xFF03624C) : Colors.red
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),


            if (tx.isSubscription && tx.nextPaymentDate != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Due Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange)),
                  Text(
                    "${tx.nextPaymentDate!.day}/${tx.nextPaymentDate!.month}/${tx.nextPaymentDate!.year}",
                    style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date Created", style: TextStyle(fontSize: 16)),
                Text("${tx.date.day}/${tx.date.month}/${tx.date.year}"),
              ],
            ),

            if (tx.isSubscription) ...[
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.center,
                child: Chip(
                  label: Text("Subscription", style: TextStyle(color: Color(0xFF03624C))),
                  backgroundColor: Color(0x2203624C),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirestoreService().deleteTransaction(tx.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transaction deleted"), backgroundColor: Colors.red),
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label: const Text("Delete Transaction", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}