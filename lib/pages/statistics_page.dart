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
        cutoffDate = now.subtract(Duration(days: 30));
        break;
      case "Year":
        cutoffDate = now.subtract(Duration(days: 365));
        break;
      default:
        cutoffDate = now.subtract(Duration(days: 30));
    }
    return widget.transactions.where((tx) => tx.date.isAfter(cutoffDate)).toList();
  }

  //Calculate total net balance
  double get totalNetBalance{
    double total = 0;
    for(var t in widget.transactions){
      if(t.type == TransactionType.income){
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }

  void _showPeriodSelector(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))
        ),
        builder: (context) {
          return Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Period',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text('Month', style: TextStyle(fontSize: 16),),
                      onTap: (){
                        setState(() {
                          _selectedPeriod = "Month";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.black26),
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
                //Net Balance
                Container(
                  height: 125,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF03624C),
                  ),
                  child:Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text("Total Net Balance", style: TextStyle(fontSize: 15, color: Color(0xFFF0F5F3))),
                            Text(
                              "৳${totalNetBalance.toStringAsFixed(2)}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xFFF0F5F3)),
                            ),
                          ],
                      ),
                  ),
                ),

                SizedBox(height: 20),

                MonthlySummaryCard(transactions: widget.transactions),

                ExpensePieChart(transactions: widget.transactions),

                SizedBox(height: 2),

                //Line Graph
                Container(
                  height: 288,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFF0F5F3),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: LineGraph(
                      transactions: _filteredTransactions,
                      periodText: _selectedPeriod,
                      onPeriodTap: _showPeriodSelector,
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }
}