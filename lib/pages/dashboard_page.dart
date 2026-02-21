import 'package:flutter/material.dart';
import 'package:khorcha/pages/profile_page.dart';
import 'package:khorcha/pages/upcoming_payments_page.dart';
import 'package:khorcha/widgets/balance_card.dart';
import 'package:khorcha/widgets/dashboard_header.dart';
import 'package:khorcha/widgets/recent_transactions_card.dart';
import 'package:khorcha/widgets/section_title.dart';
import 'package:khorcha/widgets/upcoming_payment_card.dart';
import 'package:khorcha/models/transactions.dart';

import 'all_transactions_page.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback onAddPressed;

  const DashboardPage({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final List<TransactionModel> allTransactions = [
      TransactionModel(id: '1', title: "Grocery", amount: 450.0, date: DateTime.now(), category: "Food", type: TransactionType.expense,),
      TransactionModel(id: '2', title: "Freelance", amount: 12000.0, date: DateTime.now(), category: "Work", type: TransactionType.income,),
      TransactionModel(id: '3', title: "Spotify", amount: 100.0, date: DateTime.now(), category: "Entertainment", type: TransactionType.expense, isSubscription: true,),
      TransactionModel(id: '1', title: "Grocery", amount: 450.0, date: DateTime.now(), category: "Food", type: TransactionType.expense,),
      TransactionModel(id: '2', title: "Freelance", amount: 12000.0, date: DateTime.now(), category: "Work", type: TransactionType.income,),
      TransactionModel(id: '3', title: "Spotify", amount: 100.0, date: DateTime.now(), category: "Entertainment", type: TransactionType.expense, isSubscription: true,),
      TransactionModel(id: '1', title: "Grocery", amount: 450.0, date: DateTime.now(), category: "Food", type: TransactionType.expense,),
      TransactionModel(id: '2', title: "Freelance", amount: 12000.0, date: DateTime.now(), category: "Work", type: TransactionType.income,),
      TransactionModel(id: '3', title: "Spotify", amount: 100.0, date: DateTime.now(), category: "Entertainment", type: TransactionType.expense, isSubscription: true,),
      TransactionModel(id: '1', title: "Grocery", amount: 450.0, date: DateTime.now(), category: "Food", type: TransactionType.expense,)
    ];

    double totalExpense = 0.0;
    for (var tx in allTransactions) {
      if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      }
    }

    final List<TransactionModel> upcomingPayments = allTransactions.where((tx) => tx.isSubscription == true).toList();

    return SafeArea(
      child: ListView(
        physics:  AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 10),
          DashboardHeader(name: "Shakibul Alam",
            onProfilePressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          SizedBox(height: 15),

          BalanceCard(
            onAddPressed: onAddPressed,
            totalExpense: totalExpense,
          ),
          SizedBox(height: 15),

          SectionTitle(
            title: "Upcoming payments",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingPaymentsPage(
                    payments: allTransactions.where((t) => t.isSubscription).toList(),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 10),

          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:  EdgeInsets.symmetric(horizontal: 20),
              itemCount: upcomingPayments.length,
              itemBuilder: (context, index) {
                final payment = upcomingPayments[index];
                return UpcomingPaymentCard(payment: payment);
              },
            ),
          ),

          SizedBox(height: 15),

          SectionTitle(
            title: "Recent Transactions",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllTransactionsPage(
                    transactions: allTransactions,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 15),

          ListView.builder(
            shrinkWrap: true,
            physics:  NeverScrollableScrollPhysics(),
            itemCount: allTransactions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final tx = allTransactions[index];
              return RecentTransactionsCard(transaction: tx);
            },
          ),
        ],
      ),
    );
  }
}