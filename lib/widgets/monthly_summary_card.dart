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

    double income = 0;
    double expense = 0;

    for (int i = 0; i < thisMonthTransactions.length; i++) {
      var t = thisMonthTransactions[i];
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return {'income' : income, 'expense' : expense};
  }

  Widget _buildCard({required String title, required double amount, required IconData icon, required Color color}) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF0F5F3),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:  Colors.white,
            child: Icon(icon, color: color,size: 25),
          ),
          SizedBox(width: 12),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('৳${amount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,)
                  ),
                  const Text('Current month',
                    style: TextStyle(fontSize: 9),
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: 2,
          itemBuilder: (context, index){
            return index == 0
                ? _buildCard(
                title: 'Income',
                amount: totals['income']!,
                icon: Icons.trending_up,
                color: Color(0xFF03624C)
                )
                : _buildCard(
                title: 'Expense',
                amount: totals['expense']!,
                icon: Icons.trending_down,
                color: Colors.red.shade900
                );
          }
      ),
    );
  }
}
