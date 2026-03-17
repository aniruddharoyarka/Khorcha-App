import 'package:flutter/material.dart';

class BudgetCard extends StatefulWidget {
  final double spent;
  final double total;

  const BudgetCard({
    super.key,
    required this.spent,
    required this.total,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.total == 0 ? 0 : (widget.spent / widget.total).clamp(0, 1);
    double remaining = widget.total - widget.spent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFF0F5F3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Monthly Budget",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "৳${widget.spent.toStringAsFixed(0)} / ৳${widget.total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔹 Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 1
                      ? Colors.red
                      : Color(0xFF03624C),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔹 Bottom Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  remaining >= 0
                      ? "Remaining: ৳${remaining.toStringAsFixed(0)}"
                      : "Over budget!",
                  style: TextStyle(
                    fontSize: 13,
                    color: remaining >= 0 ? Colors.black87 : Colors.red,
                  ),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}