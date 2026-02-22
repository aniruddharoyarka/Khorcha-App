import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String name;
  final VoidCallback onProfilePressed;
  final VoidCallback onStatisticsPressed;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.onProfilePressed,
    required this.onStatisticsPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome", style: TextStyle(fontSize: 25)),
              Text(
                name,
                style: TextStyle(fontSize: 25, height: 1.1, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Updated Profile Button
          GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF03624C),
              child: Icon(Icons.person, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}