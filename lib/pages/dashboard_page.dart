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

    // UPDATED: Sample data now matches the new TransactionModel requirements
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

    final double totalExpense = allTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    // 1. Get ONLY subscriptions (where isSubscription is true)
    final List<TransactionModel> upcomingPayments = allTransactions
        .where((tx) => tx.isSubscription == true)
        .toList();

// 2. Get ONLY standard transactions (not subscriptions) for the Recent list
// Or keep it as all transactions if you want both to show up there
    final List<TransactionModel> recentTransactions = allTransactions
        .where((tx) => !tx.isSubscription)
        .toList();

    return SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 10),
          DashboardHeader(name: "Shakibul Alam",
            onProfilePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          const SizedBox(height: 15),

          BalanceCard(
            onAddPressed: onAddPressed,
            totalExpense: totalExpense,
          ),

          const SizedBox(height: 15),

          SectionTitle(
            title: "Upcoming payments",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingPaymentsPage(
                    // We pass the master list so the new page can show them
                    payments: allTransactions.where((t) => t.isSubscription).toList(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    transactions: allTransactions, // Passing the full list
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 15),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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