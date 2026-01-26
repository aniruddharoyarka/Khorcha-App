import 'package:flutter/material.dart';

class RecentTransactionsCard extends StatefulWidget {
  const RecentTransactionsCard({super.key});

  @override
  State<RecentTransactionsCard> createState() => _RecentTransactionsCardState();
}

class _RecentTransactionsCardState extends State<RecentTransactionsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 80,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Color(0xDFE8E8E8),
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}
