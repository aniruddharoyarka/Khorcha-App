import 'package:flutter/material.dart';
import 'package:khorcha/pages/profile_page.dart';
import 'package:khorcha/pages/statistics_page.dart';
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
  final List<TransactionModel> transactions;

  const DashboardPage({super.key, required this.onAddPressed, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // 1. Get ONLY subscriptions (where isSubscription is true)
    final List<TransactionModel> upcomingPayments = transactions
        .where((tx) => tx.isSubscription == true)
        .toList();

// 2. Get ONLY standard transactions (not subscriptions) for the Recent list
// Or keep it as all transactions if you want both to show up there
    final List<TransactionModel> recentTransactions = transactions
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
            onStatisticsPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsPage(transactions: transactions,))
              );
            }
          ),
          const SizedBox(height: 15),

          BalanceCard(onAddPressed: onAddPressed),

          const SizedBox(height: 15),

          SectionTitle(
            title: "Upcoming payments",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingPaymentsPage(
                    // We pass the master list so the new page can show them
                    payments: transactions.where((t) => t.isSubscription).toList(),
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
                    transactions: transactions, // Passing the full list
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 15),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return RecentTransactionsCard(transaction: tx);
            },
          ),
        ],
      ),
    );
  }
}