import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khorcha/models/transactions.dart';

/*class LineGraph extends StatefulWidget{
  const LineGraph({super.key});

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph>{
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Income vs Expense', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        SizedBox(height: 20,),
        SizedBox(
          height: 200,
          child: Padding(
              padding: EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value){
                    return FlLine(
                      color: Colors.black54,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta)
                    )
                  )
                )
              )
            ),
          ),
        ),
      ],
    );
  }
}*/