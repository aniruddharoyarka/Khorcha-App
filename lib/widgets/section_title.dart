import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

   SectionTitle({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style:  TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          GestureDetector(
            onTap: onSeeAll,
            child:  Text("See all", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}