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

List<TransactionModel> getLastMonthTransactions(List<TransactionModel> transactions){
  DateTime now = DateTime.now();
  DateTime lastMonth = DateTime(now.year, now.month-1);

  return transactions.where((t) => t.date.month == lastMonth.month && t.date.year == lastMonth.year).toList();
}

double _calculateGuiltPercentage(List<TransactionModel> transactions){
  if (transactions.isEmpty) return 0;
  double total = 0;

  for(var t in transactions){
    total += t.guiltValue;
  }
  return total / transactions.length;
}

String guiltMessage(double value){
  if(value > 0){
    return "You were ${value.toStringAsFixed(0)}% happy with your spending last month";
  } else if (value < 0){
    return "You were ${value.abs().toStringAsFixed(0)}% sad with your spending last month";
  }
  return "You were neutral with your spending last month";
}


class _StatisticsPageState extends State<StatisticsPage>{
  @override
  Widget build(BuildContext context) {
    String highestExpenseTitle = "";
    double highestExpenseAmount = 0;
    String highestIncomeTitle = "";
    double highestIncomeAmount = 0;

    final lastMonthTransactions = getLastMonthTransactions(widget.transactions);
    double guiltPercentage = _calculateGuiltPercentage(lastMonthTransactions);

    for(var t in widget.transactions){
      if(t.type == TransactionType.expense){
        if(t.amount > highestExpenseAmount){
          highestExpenseAmount = t.amount;
          highestExpenseTitle = t.title;
        }
      }
    }

    for(var t in widget.transactions){
      if(t.type == TransactionType.income){
        if(t.amount > highestIncomeAmount){
          highestIncomeAmount = t.amount;
          highestIncomeTitle = t.title;
        }
      }
    }

    return Scaffold(
        backgroundColor: Color(0xFFF9FFFC),
        appBar: AppBar(
          title: Text("Statistics",),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20),
              children: [
                MonthlySummaryCard(transactions: widget.transactions),

                ExpensePieChart(transactions: widget.transactions),

                Row(
                  children: [
                    //Highest Expense
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 7),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F5F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text('Highest Expense',
                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                            SizedBox(height: 5),
                            Text(highestExpenseTitle,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
                            Text("৳${highestExpenseAmount.toStringAsFixed(0)}",
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
                          ],
                        ),
                      ),
                    ),

                    //Highest Income
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 7, right: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F5F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text('Highest Income',
                                style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                            SizedBox(height: 5),
                            Text(highestIncomeTitle,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
                            Text("৳${highestIncomeAmount.toStringAsFixed(0)}",
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F5F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                    Text(guiltMessage(guiltPercentage), textAlign: TextAlign.center),
                  ),
              ]
          ),
        )
    );
  }
}