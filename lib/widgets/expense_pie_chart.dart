import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  const ExpensePieChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final allExpenses = transactions.where((t) => t.type == TransactionType.expense).toList();
    final totalExpense = allExpenses.fold(0.0, (sum, t) => sum + t.amount);
    final Map<String, double> categoryAmounts = {};

    for(var transaction in allExpenses){
      categoryAmounts[transaction.category] = (categoryAmounts[transaction.category] ?? 0) + transaction.amount;
    }

    final List<Color> pieColors = [
      Colors.blue, Colors.orange, Colors.teal, Colors.pink, Colors.brown, Colors.cyan, Colors.purple, Colors.lime
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF9FFFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          //PieChart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: List.generate(categoryAmounts.length, (index){
                  final category = categoryAmounts.keys.elementAt(index);
                  final amount = categoryAmounts[category]!;
                  return PieChartSectionData(
                    value: amount,
                    color: pieColors[index % pieColors.length],
                    radius: 90,
                  );
                }
              )
            ),
          )
          ),
          const SizedBox(height: 20),
          //Category List
          ...categoryAmounts.entries.map((entry){
            final index = categoryAmounts.keys.toList().indexOf(entry.key);
            final percentage = (entry.value / totalExpense) * 100;

            return Padding(
                padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: pieColors[index % pieColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                        entry.key, style: TextStyle(fontSize: 14),
                      ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
