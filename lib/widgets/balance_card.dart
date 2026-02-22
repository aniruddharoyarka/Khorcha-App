import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final VoidCallback onAddPressed;
  final double totalExpense;
  const BalanceCard({
    super.key,
    required this.onAddPressed,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0x78F5FFFC), Color(0x7700987B)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Expense", style: TextStyle(fontSize: 15)),
                  Text(
                    "৳${totalExpense.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
                child: Icon(Icons.add, size: 30, color: Color(0xFF03624C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}