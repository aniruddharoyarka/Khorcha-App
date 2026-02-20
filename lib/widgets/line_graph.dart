import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khorcha/models/transactions.dart';

class LineGraph extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String periodText;
  final VoidCallback? onPeriodTap;

  const LineGraph({
    super.key,
    required this.transactions,
    this.periodText = "Month",
    this.onPeriodTap,
  });

  //Calculate total net worth
  double get totalNetWorth{
    double total = 0;
    for(var t in transactions){
      if(t.type == TransactionType.income){
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }

  List<FlSpot> get graphSpots{
    if(transactions.isEmpty) return [];

    var sorted = List<TransactionModel>.from(transactions)
      ..sort((a,b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [];
    double runningTotal = 0;

    for(int i = 0; i < sorted.length; i++) {
      var t = sorted[i];
      if(t.type == TransactionType.income){
        runningTotal += t.amount;
      } else{
        runningTotal -= t.amount;
      }
      spots.add(FlSpot(i.toDouble(), runningTotal));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header with period selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Net Worth", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
              GestureDetector(
                onTap: onPeriodTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF03624C),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Text(periodText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),),
                      Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFFF9FFFC),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),

        SizedBox(
          height: 180,
          child: Padding(
              padding: EdgeInsets.only(right: 16, left: 8),
            child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta){
                          int index = value.toInt();
                          if(index >= 0 && index < transactions.length){
                            var date = transactions[index].date;
                            return Padding(
                                padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "%{date.day}/${date.month}",
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: graphSpots,
                      isCurved: true,
                      color: Color(0xFF03624C),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData( show: true, color: const Color(0xFF03624C).withOpacity(0.1),),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ],
    );
  }
}
