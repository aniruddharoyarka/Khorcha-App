import 'package:flutter/material.dart';
//import 'package:khorcha/widgets/line_graph.dart';
import 'package:khorcha/models/transactions.dart';

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
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                child: Container(
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    /*child: LineGraph(
                      transactions: _filteredTransactions,
                      periodText: _selectedPeriod,
                      onPeriodChanged: (String newPeriod){
                        setState(() {
                          _selectedPeriod = newPeriod;
                        });
                      }
                    ),*/
                  ),
                ),
              ),
            ]
          ),
        )
    );
  }
}