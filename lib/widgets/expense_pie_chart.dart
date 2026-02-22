import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ExpensePieChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final allExpenses = transactions.where((t) =>
    t.type == TransactionType.expense).toList();
    final totalExpense = allExpenses.fold(0.0, (sum, t) => sum + t.amount);
    final Map<String, double> categoryAmounts = {};

    for (int i = 0; i < allExpenses.length; i++) {
      var transaction = allExpenses[i];
      categoryAmounts[transaction.category] =
          (categoryAmounts[transaction.category] ?? 0) + transaction.amount;
    }

    final List<Color> pieColors = [
      const Color(0xFF64B5F6),
      const Color(0xFF81C784),
      const Color(0xFFFFB74D),
      const Color(0xFFE57373),
      const Color(0xFFBA68C8),
      const Color(0xFF4FC3F7),
      const Color(0xFFAED581),
      const Color(0xFFFF8A65),
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xFFF0F5F3),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Text(
                'Expenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Category wise',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
              ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  //PieChart
                  child: SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: List.generate(
                            categoryAmounts.length, (index) {
                          final category = categoryAmounts.keys.elementAt(
                              index);
                          final amount = categoryAmounts[category]!;
                          return PieChartSectionData(
                            value: amount,
                            color: pieColors[index % pieColors.length],
                            radius: 40,
                            title: '',
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                //Category List
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categoryAmounts.entries.map((entry) {
                      final index = categoryAmounts.keys.toList().indexOf(entry
                          .key);
                      final percentage = (entry.value / totalExpense) * 100;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: pieColors[index % pieColors.length],
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                entry.key, style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

