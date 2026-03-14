import 'package:flutter/material.dart';
import 'package:khorcha/models/transactions.dart';

class MonthlySummaryCard extends StatefulWidget {
  final List<TransactionModel> transactions;
  const MonthlySummaryCard({super.key, required this.transactions});

  @override
  State<MonthlySummaryCard> createState() => _MonthlySummaryCardState();
}

class _MonthlySummaryCardState extends State<MonthlySummaryCard>{
  DateTime _currentMonth = DateTime.now();

  String _getMonthName(int month) {
    switch(month) {
      case 1: return "January";
      case 2: return "February";
      case 3: return "March";
      case 4: return "April";
      case 5: return "May";
      case 6: return "June";
      case 7: return "July";
      case 8: return "August";
      case 9: return "September";
      case 10: return "October";
      case 11: return "November";
      case 12: return "December";
      default: return "";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,


      ),
    );
  }
}
