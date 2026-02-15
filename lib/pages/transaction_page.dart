import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedType;
  String? _selectedCategory;
  DateTime? _selectedDate;

  // Subscription Logic Variables
  bool _isSubscription = false;
  int _billingCycle = 1;

  final List<String> _types = ['Income', 'Expense'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Gift', 'Other'];
  final List<String> _expenseCategories = ['Food', 'Grocery', 'Internet', 'Rent', 'Travel', 'Other'];

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((value) {
      if(value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFC),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Add Transaction',
            style: TextStyle(
                fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF03624C),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Title Input (Important for Subscription names like "Spotify")
              _buildInputField(label: "Title", child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "e.g. Spotify", border: InputBorder.none),
                validator: (v) => v!.isEmpty ? "Enter a title" : null,
              )),

              // 2. Type Dropdown
              _buildInputField(label: "Type", child: DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() {
                  _selectedType = val;
                  _selectedCategory = null; // Reset category when type changes
                  if (val == 'Income') _isSubscription = false; // Subscriptions are usually expenses
                }),
                decoration: const InputDecoration(border: InputBorder.none, hintText: "Select Type"),
              )),

              // 3. Date Picker
              _buildInputField(label: "Date", child: GestureDetector(
                onTap: _showDatePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(_selectedDate == null ? "Select Date" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: Color(0xFF03624C)),
                  ],
                ),
              )),

              // 4. Category Dropdown
              _buildInputField(label: "Category", child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: (_selectedType == 'Income' ? _incomeCategories : _expenseCategories)
                    .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: const InputDecoration(border: InputBorder.none, hintText: "Select Category"),
                validator: (val) => val == null ? "Select a category" : null,
              )),

              // 5. Amount Input
              _buildInputField(label: "Amount", child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixText: "৳ ", border: InputBorder.none),
                validator: (v) => v!.isEmpty ? "Enter amount" : null,
              )),

              // 6. Subscription Toggle (Only for Expenses)
              if (_selectedType == 'Expense') ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Mark as Subscription", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Switch(
                      value: _isSubscription,
                      activeColor: const Color(0xFF03624C),
                      onChanged: (val) => setState(() => _isSubscription = val),
                    ),
                  ],
                ),
              ],

              // 7. Conditional Billing Cycle
              if (_isSubscription && _selectedType == 'Expense')
                _buildInputField(label: "Every", child: TextFormField(
                  initialValue: '1',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(suffixText: "Months", border: InputBorder.none),
                  onChanged: (val) => _billingCycle = int.tryParse(val) ?? 1,
                )),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03624C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Transaction", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to keep the UI consistent and code shorter
  Widget _buildInputField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFF0F5F3), borderRadius: BorderRadius.circular(12)),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Logic to calculate next payment
      DateTime? nextPaymentDate;
      if (_isSubscription) {
        nextPaymentDate = DateTime(_selectedDate!.year, _selectedDate!.month + _billingCycle, _selectedDate!.day);
      }

      print("Saving: ${_titleController.text}, Sub: $_isSubscription, Next: $nextPaymentDate");
      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date")));
    }
  }
}