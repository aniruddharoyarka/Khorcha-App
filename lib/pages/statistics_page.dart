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
  String _selectedPeriod = "Month";

  List<TransactionModel> get _filteredTransactions {
    DateTime now = DateTime.now();
    DateTime cutoffDate;

    switch(_selectedPeriod){
      case "Month":
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case "Year":
        cutoffDate = now.subtract(const Duration(days: 365));
        break;
      default:
        cutoffDate = now.subtract(const Duration(days: 30));
    }
    return widget.transactions.where((tx) => tx.date.isAfter(cutoffDate)).toList();
  }

  void _showPeriodSelector(){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))
        ),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Period',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text('Month', style: TextStyle(fontSize: 16),),
                      onTap: (){
                        setState(() {
                          _selectedPeriod = "Month";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black26),
                    ListTile(
                      title: Text('Year', style: TextStyle(fontSize: 16),),
                      onTap: (){
                        setState(() {
                          _selectedPeriod = "Year";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 20),
                  ]
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9FFFC),
        appBar: AppBar(
          title: Text("Statistics"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                //Line Graph
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 288,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0x33F5FFFC), Color(0x3300987B),],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: LineGraph(
                          transactions: _filteredTransactions,
                          periodText: _selectedPeriod,
                          onPeriodTap: _showPeriodSelector,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                MonthlySummaryCard(transactions: widget.transactions),

                const SizedBox(height: 10),

                ExpensePieChart(transactions: widget.transactions),

              ]
          ),
        )
    );
  }
}