import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class MonthlySummaryCard extends StatelessWidget {
  final List<TransactionModel> transactions;

  const MonthlySummaryCard({super.key, required this.transactions});

  Map<String, double> _calculateThisMonthTotals(){
    final now = DateTime.now();
    final thisMonthTransactions = transactions.where((t){
      return t.date.month == now.month && t.date.year == now.year;
    }).toList();

    double income = thisMonthTransactions.where((t) => t.type == TransactionType.income)
      .fold(0, (sum,t) => sum + t.amount);

    double expense = thisMonthTransactions.where((t) => t.type == TransactionType.expense)
      .fold(0,(sum,t) => sum + t.amount);
    return {'income' : income, 'expense' : expense};
  }

  Widget _buildCard({required String title, required double amount, required IconData icon, required Color color}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:  const Color(0xFF03624C),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:  Colors.white,
            child: Icon(icon, color: color,size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('৳${amount.toStringAsFixed(2)}',
                    style: TextStyle(color : Colors.white, fontWeight: FontWeight.bold, fontSize: 18,)
                  ),
                  const Text('Current month',
                    style: TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = _calculateThisMonthTotals();
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 2,
          itemBuilder: (context, index){
            return index == 0
                ? _buildCard(
                title: 'Income',
                amount: totals['income']!,
                icon: Icons.arrow_upward,
                color: const Color(0xFF03624C)
                )
                : _buildCard(
                title: 'Expense',
                amount: totals['expense']!,
                icon: Icons.arrow_downward,
                color: Colors.red.shade900
                );
          }
      ),
    );
  }
}
