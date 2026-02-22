import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khorcha/models/transactions.dart';

class GraphDataSet {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<String> labels;
  final double maxY;

  GraphDataSet({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labels,
    required this.maxY,
  });
}

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

  // Get unique transactions by date (last transaction of each day)
  List<TransactionModel> _getDailyUniqueTransactions(){
    Map<String, TransactionModel> dailyMap = {};

    List<TransactionModel> sorted = List.from(transactions);
    sorted.sort((a, b) => a.date.compareTo(b.date));

    for (int i = 0; i < sorted.length; i++) {
      var t = sorted[i];
      String dataKey = "${t.date.year}-${t.date.month}-${t.date.day}";
      dailyMap[dataKey] = t;
    }
    var result = dailyMap.values.toList();
    result.sort((a,b) => a.date.compareTo(b.date));
    return result;
  }

  GraphDataSet _getGraphData() {
    final dailyTransactions = _getDailyUniqueTransactions();
    if (dailyTransactions.isEmpty) {
      return GraphDataSet(
        incomeSpots: [],
        expenseSpots: [],
        labels: [],
        maxY: 5000,
      );
    }
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    List<String> xLabels = [];

    double runningIncome = 0;
    double runningExpense = 0;
    double maxValue = 0;

    for (int i = 0; i < dailyTransactions.length; i++) {
      final t = dailyTransactions[i];

      if (t.type == TransactionType.income) runningIncome += t.amount;
      else runningExpense += t.amount;

      incomeSpots.add(FlSpot(i.toDouble(), runningIncome));
      expenseSpots.add(FlSpot(i.toDouble(), runningExpense));

      maxValue = maxValue < runningIncome ? runningIncome : maxValue;
      maxValue = maxValue < runningExpense ? runningExpense : maxValue;

      String label = _formatDate(t.date);
      xLabels.add(label);
    }
    double maxY = (maxValue * 1.2);
    maxY = (maxY / 1000).ceil() * 1000.0;

    return GraphDataSet(
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
      labels: xLabels,
      maxY: maxY,
    );
  }

  String _formatDate(DateTime date){
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if(periodText == "Year"){
      return '${date.year}';
    } else{
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  List<String> _getReducedLabels(List<String> allLabels) {
    if (allLabels.length <= 5) return allLabels;

    List<String> result = [];
    int step = (allLabels.length / 4).floor();

    for (int i = 0; i < 4; i++) {
      int index = i * step;
      if (index < allLabels.length) {
        result.add(allLabels[index]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final graphData = _getGraphData();
    final incomeSpots = graphData.incomeSpots;
    final expenseSpots = graphData.expenseSpots;
    final allLabels = graphData.labels;
    final maxY = graphData.maxY;
    final xLabels = _getReducedLabels(allLabels);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header with period selector
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Income vs Expense', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, ),)
                ],
              ),
              GestureDetector(
                onTap: onPeriodTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF03624C),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(periodText, style: TextStyle(fontSize: 12,color: Colors.white),),
                      Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
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
          height: 197,
          child: Padding(
            padding: EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: LineChart(
              LineChartData(
                gridData:  FlGridData(
                    show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY/4,
                  getDrawingHorizontalLine: (value){
                      return FlLine(
                        color: Colors.grey[600]!,
                        strokeWidth: 0.5,
                         dashArray: [5, 5]
                      );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      interval: 1,
                      getTitlesWidget: (value, meta){
                        int index = value.toInt() - 1;
                        if (index >= 0 && index < allLabels.length) {
                          String label = allLabels[index];
                          if(xLabels.contains(label)){
                            return Padding(
                              padding: EdgeInsets.only(top: 8,),
                              child: Text(label, style: TextStyle(fontSize: 10),),
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
                      reservedSize: 40,
                      interval: maxY/4,
                      getTitlesWidget: (value, meta) {
                        String text;
                        if (value == 0) {
                          text = '0';
                        } else if (value >= 1000) {
                          text = '${(value / 1000).toStringAsFixed(0)}K';
                        } else {
                          text = value.toStringAsFixed(0);
                        }
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(text, style: TextStyle(fontSize: 10,), textAlign: TextAlign.right,),);
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false,),
                minX: 0.5,
                maxX: (allLabels.length-1).toDouble() - 0.5,
                minY: 0,
                maxY: maxY ,
                clipData: FlClipData.all(),

                //Income Line
                lineBarsData: [
                  LineChartBarData(
                    spots: incomeSpots,
                    isCurved: true,
                    color: Color(0xFF03624C),
                    barWidth: 2.5,
                    dotData: FlDotData(show: false),
                  ),

                //Expense Line
                  LineChartBarData(
                    spots: expenseSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2.5,
                    dotData: FlDotData(show: false),
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