import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class MonthlySummaryCard extends StatefulWidget {
  final List<TransactionModel> transactions;
  final DateTime currentMonth;
  final Function(DateTime) onMonthChanged;
  const MonthlySummaryCard({super.key, required this.transactions,required this.currentMonth, required this.onMonthChanged,});

  @override
  State<MonthlySummaryCard> createState() => _MonthlySummaryCardState();
}

class _MonthlySummaryCardState extends State<MonthlySummaryCard>{

  @override
  void didUpdateWidget(MonthlySummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalculate if the month or the underlying transaction list changes
    if (widget.currentMonth != oldWidget.currentMonth ||
        widget.transactions != oldWidget.transactions) {
      _calculateMonthData();
    }
  }

  double income = 0;
  double expense = 0;

  String getMonth(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

  void _calculateMonthData(){
    double newIncome = 0;
    double newExpense = 0;

    for (var t in widget.transactions){
      if(t.date.year == widget.currentMonth.year && t.date.month == widget.currentMonth.month){
        if(t.type == TransactionType.income){
          newIncome += t.amount;
        }
        else{
          newExpense += t.amount;
        }
      }
    }
    setState(() {
      income = newIncome;
      expense = newExpense;
    });
  }

  void _previousMonth() {
    final newMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month - 1);
    widget.onMonthChanged(newMonth);
  }

  void _nextMonth() {
    final newMonth = DateTime(widget.currentMonth.year, widget.currentMonth.month + 1);
    widget.onMonthChanged(newMonth);
  }

  @override
  void initState() {
    super.initState();
    _calculateMonthData();
  }

  @override
  Widget build(BuildContext context) {
    //double currentBalance = income - expense;
    return Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 15, top: 20),
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Color(0xFFF0F5F3),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              //Month nav
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: Icon(Icons.arrow_back_ios_rounded, size: 18, fontWeight: FontWeight.bold,),
                  ),

                  Text(
                    "${getMonth(widget.currentMonth.month)} ${widget.currentMonth.year}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),

                  IconButton(
                    onPressed: _nextMonth,
                    icon: Icon(Icons.arrow_forward_ios_rounded,size: 18,fontWeight: FontWeight.bold,),
                  )
                ],
              ),
          
             /* //Current Balance
              SizedBox(height: 5),
              Text("Current Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text("৳${currentBalance.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 28, color: Color(0xFF03624C),fontWeight: FontWeight.w500),
              ),*/
                
              //Calculated Income-Expense 
              SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_downward_rounded, color: Color(0xFF03624C), size: 20,fontWeight: FontWeight.bold),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Income", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(
                              "৳${income.toStringAsFixed(0)}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                            ),
                          ],
                        )
                      ],
                    ),

                    Container(height: 30, width: 2, color: Colors.black12),

                    Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded, color: Colors.red, size: 20, fontWeight: FontWeight.bold),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expense", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(
                              "৳${expense.toStringAsFixed(0)}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
                ]
              ),
            ),
    );
  }
}
