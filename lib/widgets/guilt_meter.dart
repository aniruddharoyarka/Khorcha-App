import 'package:flutter/material.dart';

class GuiltMeter extends StatefulWidget {
  final Function(double) onValueVisibilityChanged;
  const GuiltMeter({super.key, required this.onValueVisibilityChanged});

  @override
  State<GuiltMeter> createState() => _GuiltMeter();
}

class _GuiltMeter extends State<GuiltMeter> {
  double guiltValue = 0;

  Color getColor(){
    if(guiltValue < 0) return Colors.red;
    if(guiltValue ==0) return Color(0xFFF0F5F3);
    return Color(0xFF03624C);
  }

  String getMessage() {
    if(guiltValue < 0) return "That hurts a bit";
    if(guiltValue == 0) return "It was necessary";
    return "You earned this";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(guiltValue != 0)
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFF0F5F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(getMessage(), textAlign: TextAlign.center),
          ),

        Slider(
            value: guiltValue,
            min: -100,
            max: 100,
            activeColor: Color(0xFF03624C),
            thumbColor: getColor(),
            onChanged: (value){
              setState(() {
                if(value < -50){
                  guiltValue = -100;
                } else if(value > 50){
                  guiltValue = 100;
                } else{
                  guiltValue = 0;
                }
              });
              widget.onValueVisibilityChanged(guiltValue);
            }
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text("Sad", textAlign: TextAlign.center),
            Text("Neutral", textAlign: TextAlign.center),
            Text("Happy", textAlign: TextAlign.center)
          ],
        ),
      ],
    );
  }
}
