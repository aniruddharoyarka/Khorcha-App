import 'package:flutter/material.dart';
import 'package:khorcha/pages/dashboard_page.dart';
import 'package:khorcha/pages/statistics_page.dart';
import 'package:khorcha/pages/transaction_page.dart';
import 'package:khorcha/models/transactions.dart';
import 'package:khorcha/widgets/line_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // UPDATED: Sample data now matches the new TransactionModel requirements
  final List<TransactionModel> allTransactions = [
    TransactionModel(id: '1', title: "Grocery", amount: 450.0, date: DateTime.now().subtract(Duration(days: 25)), category: "Food", type: TransactionType.expense,),
    TransactionModel(id: '2', title: "Freelance", amount: 3000.0, date: DateTime.now().subtract(Duration(days: 15)), category: "Work", type: TransactionType.income,),
    TransactionModel(id: '3', title: "Spotify", amount: 100.0, date: DateTime.now(), category: "Entertainment", type: TransactionType.expense, isSubscription: true,),
    TransactionModel(id: '4', title: "Salary", amount: 4000.0, date: DateTime.now().subtract(const Duration(days: 28)), category: "Work", type: TransactionType.income,),
    TransactionModel(id: '5', title: "Rent", amount: 1000.0, date: DateTime.now().subtract(const Duration(days: 20)), category: "Housing", type: TransactionType.expense,),
    TransactionModel(id: '6', title: "Electricity Bill", amount: 350.0, date: DateTime.now().subtract(const Duration(days: 18)), category: "Utilities", type: TransactionType.expense,),
    TransactionModel(id: '7', title: "Internet", amount: 250.0, date: DateTime.now().subtract(const Duration(days: 16)), category: "Utilities", type: TransactionType.expense, isSubscription: true,),
    //TransactionModel(id: '2', title: "Freelance", amount: 3000.0, date: DateTime.now().subtract(Duration(days: 15)), category: "Work", type: TransactionType.income,),
    //TransactionModel(id: '3', title: "Spotify", amount: 100.0, date: DateTime.now(), category: "Entertainment", type: TransactionType.expense, isSubscription: true,),
  ];

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
      backgroundColor: const Color(0xFFF9FFFC),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            onAddPressed: _navigateToTransactionPage,
            transactions: allTransactions,
          ),
          StatisticsPage(transactions: allTransactions),
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
        selectedItemColor: const Color(0xFF03624C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Statistics",
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTransactionPage,
        backgroundColor: const Color(0xFF03624C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
