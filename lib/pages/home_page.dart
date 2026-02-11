import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khorcha/pages/recent_transactions_card.dart';
import 'package:khorcha/pages/upcoming_payment_card.dart';

import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/models/upcoming_payment_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<TransactionModel> transactions = [
    TransactionModel(title: "Grocery", amount: "-৳450", icon: Icons.shopping_cart),
    TransactionModel(title: "Freelance", amount: "+৳12,000", icon: Icons.payments),
    TransactionModel(title: "Internet Bill", amount: "-৳500", icon: Icons.wifi),
    TransactionModel(title: "Food", amount: "-৳250", icon: Icons.food_bank),
    TransactionModel(title: "Electricity Bill", amount: "-৳200", icon: Icons.lightbulb),
    TransactionModel(title: "Water Bill", amount: "-৳100", icon: Icons.water_drop),
    TransactionModel(title: "Phone Bill", amount: "-৳150", icon: Icons.phone_android),
    TransactionModel(title: "Gym", amount: "-৳100", icon: Icons.sports_gymnastics),
    TransactionModel(title: "Netflix", amount: "-৳200", icon: Icons.movie),
    TransactionModel(title: "Spotify", amount: "-৳100", icon: Icons.music_note),
  ];

  final List<UpcomingPaymentModel> upcomingPayments = [
    UpcomingPaymentModel(title: "Spotify", amount: "৳100", icon: Icons.music_note),
    UpcomingPaymentModel(title: "Internet", amount: "৳500", icon: Icons.wifi),
    UpcomingPaymentModel(title: "Netflix", amount: "৳200", icon: Icons.movie),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      body: SafeArea(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 10),
              _buildHeader(),
              SizedBox(height: 15),
              _buildCurrentBalance(),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upcoming payments", style:
                      TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),
                      ),
                      Text("See all", style:
                      TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: upcomingPayments.length,
                  itemBuilder: (context, index) {
                    final payment = upcomingPayments[index];
                    return UpcomingPaymentCard(payment: payment);
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Transactions", style:
                      TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),
                      ),
                      Text("See all", style:
                      TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return RecentTransactionsCard(transaction: tx);
                },
              ),
            ],
          )
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF03624C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _buildBottomNav() {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8.0,
    color: Colors.white,
    elevation: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.home_filled, color: Color(0xFF03624C)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
          onPressed: () {},
        ),
        const SizedBox(width: 48),
        IconButton(
          icon: const Icon(Icons.bar_chart_outlined, color: Colors.grey),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _buildHeader() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style:
            TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.normal),
            ),
            Text("Shakibul Alam!", style:
            TextStyle(
                fontSize: 25,
                height: 1,
                fontWeight: FontWeight.bold
            ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: () {
              print("Notification Clicked");
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Icon(Icons.notifications_none,
                  size: 30,
                  color: Color(0xFF03624C)
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget _buildCurrentBalance() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0x78F5FFFC),
            Color(0x7700987B),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Expense",style:
                TextStyle(
                  fontSize: 15,
                ),
                ),
                Text("৳4,580,80",style:
                TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                ),
              ],
            ),
            ElevatedButton(onPressed: () {
              print("Add Clicked");
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Icon(Icons.add,
                  size: 30,
                  color: Color(0xFF03624C)),
            ),
          ],
        ),
      ),
    ),
  );
}
