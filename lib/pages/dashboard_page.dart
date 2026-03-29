import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khorcha/pages/profile_page.dart';
import 'package:khorcha/pages/statistics_page.dart';
import 'package:khorcha/pages/upcoming_payments_page.dart';
import 'package:khorcha/widgets/balance_card.dart';
import 'package:khorcha/widgets/budget_card.dart';
import 'package:khorcha/widgets/dashboard_header.dart';
import 'package:khorcha/widgets/recent_transactions_card.dart';
import 'package:khorcha/widgets/section_title.dart';
import 'package:khorcha/widgets/upcoming_payment_card.dart';
import 'package:khorcha/models/transactions.dart';

import 'all_transactions_page.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onAddPressed;
  final List<TransactionModel> allTransactions;

  const DashboardPage({super.key, required this.onAddPressed, required this.allTransactions});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  double? userBudget;
  bool isLoadingBudget = true;

  @override
  void initState() {
    super.initState();
    fetchBudget();
  }

  Future<void> fetchBudget() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null && doc.data()!.containsKey('budget')) {
        setState(() {
          userBudget = (doc['budget'] as num).toDouble();
          isLoadingBudget = false;
        });
      } else {
        setState(() {
          userBudget = null;
          isLoadingBudget = false;
        });
      }
    } catch (e) {
      print("Error fetching budget: $e");
      setState(() => isLoadingBudget = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    final List<TransactionModel> upcomingPayments =
    widget.allTransactions.where((tx) => tx.isSubscription).toList();

    double totalExpense = 0.0;
    for (var tx in widget.allTransactions) {
      if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      }
    }

    return SafeArea(
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 10),

          DashboardHeader(
            name: user?.displayName ?? "User",
            onProfilePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            onStatisticsPressed: () {},
          ),

          SizedBox(height: 15),

          BalanceCard(
            onAddPressed: widget.onAddPressed,
            totalExpense: totalExpense,
          ),

          SizedBox(height: 15),

          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              final data = snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null || !data.containsKey('budget')) {
                return SizedBox();
              }

              double budget = (data['budget'] as num).toDouble();

              if (budget <= 0) return SizedBox();

              return Column(
                children: [
                  BudgetCard(
                    spent: totalExpense,
                    total: budget,
                  ),
                  SizedBox(height: 15),
                ],
              );
            },
          ),

          SectionTitle(
            title: "Upcoming payments",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingPaymentsPage(
                    payments: widget.allTransactions
                        .where((t) => t.isSubscription)
                        .toList(),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 10),

          upcomingPayments.isEmpty
              ? _buildEmptyState("No upcoming payments found")
              : SizedBox(
            height: 83,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                    transactions: widget.allTransactions,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 15),

          widget.allTransactions.isEmpty
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: _buildEmptyState("No transactions found yet"),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.allTransactions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final tx = widget.allTransactions[index];
              return RecentTransactionsCard(transaction: tx);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sentiment_dissatisfied, color: Colors.grey[400], size: 30),
        SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            //fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}