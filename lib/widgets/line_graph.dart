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
    return ((max + 1000) / 1000).ceil() * 1000.0;
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

  Map<int, String> _getUniqueXLabelsWithPositions() {
    if (_uniqueTransactions.isEmpty) return {};

    var sorted = List<TransactionModel>.from(_uniqueTransactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    Map<int, String> uniqueLabelsWithPositions = {};
    Set<String> seenLabels = {};

    for (int i = 0; i < sorted.length; i++) {
      String label = _formatDate(sorted[i].date);
      if (!seenLabels.contains(label)) {
        seenLabels.add(label);
        uniqueLabelsWithPositions[i] = label; // Store at this index
      }
    }

    return uniqueLabelsWithPositions;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, String> uniqueLabelsWithPositions = _getUniqueXLabelsWithPositions();
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
                        color: Color(0xFF03624C),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                      children: [
                        Text(
                          periodText, style: TextStyle(fontSize: 12, color: Color(0xFFF9FFFC)),),
                          Icon(Icons.arrow_drop_down, size: 18,color: Color(0xFFF9FFFC)),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22),
        //Chart
        SizedBox(
          height: 180,
          child: Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
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
                          dashArray: [5, 5]
                      );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta){
                        int index = value.toInt();
                        if (uniqueLabelsWithPositions.containsKey(index)) {
                          String label = uniqueLabelsWithPositions[index]!;
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 8,
                                left: 12,
                                right: 12
                              ),
                              child: Text(
                                label,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 1000,
                      getTitlesWidget: (value, meta) {
                        // Format the Y-axis values
                        String text;
                        if (value == 0) {
                          text = '0';
                        } else if (value >= 1000) {
                          int kValue = (value / 1000).round();
                          text = '$kValue K'; // Simple concatenation
                        } else {
                          text = '${value.toInt()}';
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
                maxY: maxY,
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