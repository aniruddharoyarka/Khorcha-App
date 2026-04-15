import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  final VoidCallback onAddPressed;
  final double totalExpense;
  const BalanceCard({super.key, required this.onAddPressed, required this.totalExpense,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF03624C),
          /*
          gradient: LinearGradient(
            colors: [Color(0x78F5FFFC), Color(0xFF03624C)],
          ),

           */
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Expense", style: TextStyle(fontSize: 15,color: Colors.white)),
                  Text(
                    "৳${widget.totalExpense.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              /*
              ElevatedButton(
                onPressed: widget.onAddPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
                child: Icon(Icons.add, size: 30, color: Color(0xFF03624C)),
              ),
              \
               */
            ],
          ),
        ),
      ),
    );
  }
}