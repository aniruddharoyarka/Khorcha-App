import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khorcha/pages/recent_transactions_card.dart';
import 'package:khorcha/pages/upcoming_payment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),
                      ),
                      Text("See all", style:
                      GoogleFonts.poppins(
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
                height: 170,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    UpcomingPaymentCard(),
                    UpcomingPaymentCard(),
                    UpcomingPaymentCard(),
                    UpcomingPaymentCard(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recent Transactions", style:
                      GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),
                      ),
                      Text("See all", style:
                      GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              RecentTransactionsCard(),
              RecentTransactionsCard(),
              RecentTransactionsCard(),
              RecentTransactionsCard(),
              RecentTransactionsCard(),

            ],
          )
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Floating Button Clicked");
        },
        backgroundColor: Color(0xFF03624C),
        child: Icon(Icons.add),foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _buildBottomNav() {
  return BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin: 12,
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home_filled, color: Color(0xFF1A1D3D)),
          Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
          SizedBox(width: 40),
          Icon(Icons.bar_chart_outlined, color: Colors.grey),
          Icon(Icons.person_outline, color: Colors.grey),
        ],
      ),
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
            GoogleFonts.poppins(
              fontSize: 25,
            ),
            ),
            Text("Shakibul Alam!", style:
            GoogleFonts.poppins(
                fontSize: 25,
                height: 1,
                fontWeight: FontWeight.w700
            ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: () {
              print("Search Clicked");
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),

              ),
              child: Icon(Icons.search_outlined,
                  size: 30,
                  color: Color(0xFF03624C)
              ),
            ),
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
                Text("Current Balance",style:
                GoogleFonts.poppins(
                  fontSize: 15,
                ),
                ),
                Text("৳4,580,80",style:
                GoogleFonts.poppins(
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
