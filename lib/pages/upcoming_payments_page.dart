import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/recent_transactions_card.dart';

class UpcomingPaymentsPage extends StatelessWidget {
  final List<TransactionModel> payments;

  const UpcomingPaymentsPage({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFC),
      appBar: AppBar(
        title: const Text("Upcoming Payments"),
        centerTitle: true,
      ),
      body: payments.isEmpty
          ? const Center(child: Text("No upcoming payments found"))
          : ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return RecentTransactionsCard(transaction: payments[index]);
        },
      ),
    );
  }
}