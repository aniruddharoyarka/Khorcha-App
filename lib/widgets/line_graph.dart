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

  List<TransactionModel> get _uniqueTransactions {
    Map<String, TransactionModel> uniqueMap = {};
    for (var t in transactions) {
      uniqueMap[t.id] = t; // This will keep only the last occurrence of each ID
    }
    return uniqueMap.values.toList();
  }

  //Calculate total net worth
  double get totalNetWorth{
    double total = 0;
    for(var t in _uniqueTransactions){
      if(t.type == TransactionType.income){
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }

  // Calculate max Y value based on actual data
  double get _maxYValue {
    if (_uniqueTransactions.isEmpty) return 3000;

    double maxIncome = 0;
    double maxExpense = 0;
    double runningIncome = 0;
    double runningExpense = 0;

    var sorted = List<TransactionModel>.from(_uniqueTransactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (var t in sorted) {
      if (t.type == TransactionType.income) {
        runningIncome += t.amount;
      } else {
        runningExpense += t.amount;
      }
      maxIncome = maxIncome < runningIncome ? runningIncome : maxIncome;
      maxExpense = maxExpense < runningExpense ? runningExpense : maxExpense;
    }

    double max = maxIncome > maxExpense ? maxIncome : maxExpense;
    // Round up to nearest 1000 and add padding
    return ((max + 2000) / 2000).ceil() * 2000.0;
  }

  List<FlSpot> _getIncomeSpots(){
    if(_uniqueTransactions.isEmpty) return [];

    var sorted = List<TransactionModel>.from(_uniqueTransactions)
      ..sort((a,b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [];
    double runningIncome = 0;

    for(int i = 0; i < sorted.length; i++) {
      var t = sorted[i];
      if(t.type == TransactionType.income){
        runningIncome += t.amount;
      }
      spots.add(FlSpot(i.toDouble(), runningIncome));
    }
    return spots;
  }

  List<FlSpot> _getExpenseSpots(){
    if(_uniqueTransactions.isEmpty) return [];

    var sorted = List<TransactionModel>.from(_uniqueTransactions)
      ..sort((a,b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [];
    double runningExpense = 0;

    for(int i = 0; i < sorted.length; i++) {
      var t = sorted[i];
      if(t.type == TransactionType.expense){
        runningExpense += t.amount;
      }
      spots.add(FlSpot(i.toDouble(), runningExpense));
    }
    return spots;
  }

  String _formatDate(DateTime date){
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if(periodText == "Year"){
      return '${date.year}';
    } else{
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  List<String> _getXAxisLabels() {
    if (_uniqueTransactions.isEmpty) return [];

    var sorted = List<TransactionModel>.from(_uniqueTransactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    Set<String> uniqueDates = {};
    List<String> uniqueList = [];

    for (var t in sorted) {
      String label = _formatDate(t.date);
      if (!uniqueDates.contains(label)) {
        uniqueDates.add(label);
        uniqueList.add(label);
      }
    }

    if(uniqueList.length <= 4) return uniqueList;

    List<String> result = [];
    int step = (uniqueList.length / 4).floor();
    for (int i = 0; i < 4; i++) {
      int index = i * step;
      if (index < uniqueList.length) {
        result.add(uniqueList[index]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<String> xAxisLabels = _getXAxisLabels();
    double maxY = _maxYValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header with period selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text("Total Net Worth", style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),),
                  SizedBox(height: 5),
                  Text(
                    "\৳${totalNetWorth.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              GestureDetector(
                onTap: onPeriodTap,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FFFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [Text(
                      periodText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.arrow_drop_down, size: 18),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 22),
        //Chart
        SizedBox(
          height: 155,
          child: Padding(
            padding: EdgeInsets.only(right: 8, left: 8, bottom: 20),
            child: LineChart(
              LineChartData(
                gridData:  FlGridData(
                    show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value){
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 0.5,
                         dashArray: [2, 2]
                      );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      getTitlesWidget: (value, meta){
                        int index = value.toInt();
                        if (index >= 0 && index < _uniqueTransactions.length) {
                          String label = _formatDate(_uniqueTransactions[index].date);
                          if(xAxisLabels.contains(label)){
                            return Padding(
                              padding: EdgeInsets.only(top: 8,),
                              child: Text(
                                label,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 2000,
                      getTitlesWidget: (value, meta) {
                        // Format the Y-axis values
                        String text;
                        if (value == 0) {
                          text = '0';
                        } else if (value == 2000 || value == 4000 || value == 6000 || value == 8000) {
                          text = '${(value/1000).toInt()}K';
                        }
                        else {
                          text = '${(value/1000).toInt()}K';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false,),
                minY: 0,
                maxY: maxY ,
                //Income Line
                lineBarsData: [
                  LineChartBarData(
                    spots: _getIncomeSpots(),
                    isCurved: true,
                    color: Color(0xFF03624C),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                //Expense Line
                  LineChartBarData(
                    spots: _getExpenseSpots(),
                    isCurved: true,
                    color: Colors.red.shade900,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
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