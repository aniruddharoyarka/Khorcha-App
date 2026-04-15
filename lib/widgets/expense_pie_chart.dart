import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  final DateTime selectedMonth;
  const ExpensePieChart({super.key, required this.transactions, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    final allExpenses = transactions.where((t) =>
    t.type == TransactionType.expense &&
        t.date.month == selectedMonth.month &&
        t.date.year == selectedMonth.year
    ).toList();

    double totalExpense = 0;
    Map<String, double> categoryAmounts = {};

    for (var expense in allExpenses) {
      totalExpense += expense.amount;
      categoryAmounts[expense.category] = (categoryAmounts[expense.category] ?? 0) + expense.amount;
    }

    final sortedCategories = categoryAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<Color> pieColors = [
      const Color(0xFF64B5F6), const Color(0xFF81C784), const Color(0xFFFFB74D), const Color(0xFFE57373),
      const Color(0xFFBA68C8), const Color(0xFF4FC3F7), const Color(0xFFAED581), const Color(0xFFFF8A65),
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Category wise', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.grey[700])),
            const SizedBox(height: 15),

            if (totalExpense <= 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text("No expense data available", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ),
              )
            else ...[
              SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(sortedCategories.length, (index) {
                      return PieChartSectionData(
                        value: sortedCategories[index].value,
                        color: pieColors[index % pieColors.length],
                        radius: 35,
                        title: '',
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Column(
                children: sortedCategories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value.key;
                  final amount = entry.value.value;
                  final percentage = (amount / totalExpense) * 100;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: pieColors[index % pieColors.length], borderRadius: BorderRadius.circular(3)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(category, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                        Text('৳${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 45,
                          child: Text('${percentage.toStringAsFixed(1)}%', textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}