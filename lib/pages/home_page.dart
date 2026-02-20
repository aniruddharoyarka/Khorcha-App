import 'package:flutter/material.dart';
import 'package:khorcha/pages/dashboard_page.dart';
import 'package:khorcha/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _navigateToTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            onAddPressed: _navigateToTransactionPage,
          ),
          Center(child: Text("Statistics Page")),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF03624C),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Statictics",
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTransactionPage,
        backgroundColor:  Color(0xFF03624C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
