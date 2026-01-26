import 'package:flutter/material.dart';

class UpcomingPaymentCard extends StatelessWidget {
  const UpcomingPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 170,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
