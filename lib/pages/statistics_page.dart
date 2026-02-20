import 'package:flutter/material.dart';
import 'package:khorcha/widgets/line_graph.dart';
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

  void _showPeriodSelector(){
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFFF9FFFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        builder: (context) {
          return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width:  40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: const Text(
                      'Year',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPeriod = "Year";
                      });
                      Navigator.pop(context);
                    },
                    trailing: _selectedPeriod == "Year"
                        ? const Icon(Icons.check, color: Color(0xFF03624C))
                        : null,
                  ),

                  const SizedBox(height: 20),
                ],
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
        body: Padding(
            padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
        )
  );
  }
}