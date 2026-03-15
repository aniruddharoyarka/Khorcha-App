import 'package:flutter/material.dart';
import 'package:khorcha/widgets/expense_pie_chart.dart';
import 'package:khorcha/widgets/line_graph.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/monthly_summary_card.dart';

class StatisticsPage extends StatefulWidget {
  final List<TransactionModel> transactions;
  const StatisticsPage({super.key, required this.transactions});

  @override
    State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>{
  //Calculate total net balance
  /*double get totalNetBalance{
    double total = 0;
    for(var t in widget.transactions){
      if(t.type == TransactionType.income){
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }*/

  @override
  Widget build(BuildContext context) {
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
              ]
          ),
        )
    );
  }
}