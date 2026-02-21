import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/recent_transactions_card.dart';

class AllTransactionsPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  const AllTransactionsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      appBar: AppBar(
        title: Text("Transaction History"),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ?  Center(child: Text("No transactions yet"))
          : ListView.builder(
        padding:  EdgeInsets.only(top: 10, bottom: 20),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final sortedList = transactions..sort((a, b) => b.date.compareTo(a.date));
          return RecentTransactionsCard(transaction: sortedList[index]);
        },
      ),
    );
  }
}