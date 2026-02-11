import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khorcha/models/upcoming_payment_model.dart';

class UpcomingPaymentCard extends StatelessWidget {
  final UpcomingPaymentModel payment;

  const UpcomingPaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: payment.themeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(payment.icon, color: payment.themeColor, size: 30),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payment.title,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(payment.amount,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}