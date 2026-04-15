import 'package:flutter/material.dart';
import 'package:khorcha/widgets/expense_pie_chart.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/monthly_summary_card.dart';

class StatisticsPage extends StatefulWidget {
  final List<TransactionModel> transactions;
  const StatisticsPage({super.key, required this.transactions});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime currentMonth = DateTime.now();

  void changeMonth(DateTime newMonth) {
    setState(() {
      currentMonth = newMonth;
    });
  }

  List<TransactionModel> get filteredTransactions {
    return widget.transactions.where((t) {
      return t.date.year == currentMonth.year &&
          t.date.month == currentMonth.month;
    }).toList();
  }

  double _calculateGuiltPercentage(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return 0;
    double total = 0;
    for (var t in transactions) {
      total += t.guiltValue;
    }
    return total / transactions.length;
  }

  String guiltMessage(double value, int count) {
    if (count == 0) return "No transactions logged for this month yet.";
    if (value > 0) {
      return "You are ${value.toStringAsFixed(0)}% happy with your spending this month";
    } else if (value < 0) {
      return "You are ${value.abs().toStringAsFixed(0)}% sad with your spending this month";
    }
    return "You are neutral with your spending this month";
  }

  @override
  Widget build(BuildContext context) {
    String highestExpenseTitle = "None";
    double highestExpenseAmount = 0;
    String highestIncomeTitle = "None";
    double highestIncomeAmount = 0;

    final currentTransactions = filteredTransactions;
    double guiltPercentage = _calculateGuiltPercentage(currentTransactions);

    for (var t in currentTransactions) {
      if (t.type == TransactionType.expense) {
        if (t.amount > highestExpenseAmount) {
          highestExpenseAmount = t.amount;
          highestExpenseTitle = t.title;
        }
      } else if (t.type == TransactionType.income) {
        if (t.amount > highestIncomeAmount) {
          highestIncomeAmount = t.amount;
          highestIncomeTitle = t.title;
        }
      }
    }

    IconData guiltIcon = Icons.sentiment_neutral_rounded;
    Color guiltColor = Colors.grey[700]!;
    if (currentTransactions.isNotEmpty) {
      if (guiltPercentage > 0) {
        guiltIcon = Icons.sentiment_very_satisfied_rounded;
        guiltColor = const Color(0xFF03624C);
      } else if (guiltPercentage < 0) {
        guiltIcon = Icons.sentiment_very_dissatisfied_rounded;
        guiltColor = Colors.red[700]!;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFC),
      appBar: AppBar(
        title: const Text("Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            MonthlySummaryCard(
              transactions: widget.transactions,
              currentMonth: currentMonth,
              onMonthChanged: changeMonth,
            ),
            ExpensePieChart(transactions: currentTransactions, selectedMonth: currentMonth),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard(
                    title: "Top Expense",
                    itemTitle: highestExpenseTitle,
                    amount: highestExpenseAmount,
                    icon: Icons.trending_up_rounded,
                    color: Colors.red[400]!,
                  ),
                  const SizedBox(width: 15),
                  _buildStatCard(
                    title: "Top Income",
                    itemTitle: highestIncomeTitle,
                    amount: highestIncomeAmount,
                    icon: Icons.trending_down_rounded,
                    color: const Color(0xFF03624C),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0F5F3), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(guiltIcon, color: guiltColor, size: 32),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      guiltMessage(guiltPercentage, currentTransactions.length),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String itemTitle,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (amount <= 0)
              Text(
                "No Data Available",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              )
            else ...[
              Text(
                itemTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                "৳${amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}