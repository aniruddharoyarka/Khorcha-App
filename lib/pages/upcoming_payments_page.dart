import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/recent_transactions_card.dart';

class UpcomingPaymentsPage extends StatelessWidget {
  final List<TransactionModel> payments;

  const UpcomingPaymentsPage({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      appBar: AppBar(title: Text("Upcoming Payments"), centerTitle: true),
      body: payments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, color: Colors.grey[400], size: 40),
                  SizedBox(height: 5),
                  Text("No upcoming payments found"),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                return RecentTransactionsCard(transaction: payments[index]);
              },
            ),
    );
  }
}
