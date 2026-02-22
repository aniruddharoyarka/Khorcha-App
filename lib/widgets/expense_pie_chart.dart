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

    double totalExpense = 0;
    for (int i = 0; i < allExpenses.length; i++) {
      totalExpense = totalExpense + allExpenses[i].amount;
    }

    final Map<String, double> categoryAmounts = {};

    for (int i = 0; i < allExpenses.length; i++) {
      String category = allExpenses[i].category;
      double amount = allExpenses[i].amount;

      if (categoryAmounts[category] == null) {
        categoryAmounts[category] = amount;
      } else {
        categoryAmounts[category] = categoryAmounts[category]! + amount;
      }
    }

    final List<Color> pieColors = [
       Color(0xFF64B5F6), Color(0xFF81C784), Color(0xFFFFB74D), Color(0xFFE57373),
       Color(0xFFBA68C8), Color(0xFF4FC3F7), Color(0xFFAED581), Color(0xFFFF8A65),
    ];
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Color(0xFFF0F5F3),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Text('Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('Category wise', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w300),),
             SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  //PieChart
                  child: SizedBox(
                    height: 200,
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
                SizedBox(width: 20),

                //Category List
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categoryAmounts.entries.map((entry) {
                      final index = categoryAmounts.keys.toList().indexOf(entry.key);
                      final percentage = (entry.value / totalExpense) * 100;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
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
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(entry.key, style: TextStyle(fontSize: 10),),
                            ),
                            Text('${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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

