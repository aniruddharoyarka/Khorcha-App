import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final VoidCallback onAddPressed;
  const BalanceCard({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0x78F5FFFC), Color(0x7700987B)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Expense", style: TextStyle(fontSize: 15)),
                  Text("৳4,580.80", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                ],
              ),
              ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
                child: const Icon(Icons.add, size: 30, color: Color(0xFF03624C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}