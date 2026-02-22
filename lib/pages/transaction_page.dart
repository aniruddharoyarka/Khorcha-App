import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  String? _selectedType;
  String? _selectedCategory;
  DateTime? _selectedDate = DateTime.now();

  bool _isSubscription = false;
  int _billingCycle = 1;

  bool _isAddingCategory = false;

  final List<String> _types = ['Income', 'Expense'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Gift',];
  final List<String> _expenseCategories = ['Food', 'Grocery', 'Internet', 'Rent', 'Travel',];

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        setState(() => _selectedDate = value);
      }
    });
  }

  void _saveNewCategory() {
    String newCategory = _newCategoryController.text.trim();
    if(newCategory.isNotEmpty) {
      setState(() {
        _selectedType == 'Income' ? _incomeCategories.add(newCategory) : _expenseCategories.add(newCategory);
        _selectedCategory = newCategory;
        _isAddingCategory = false;
        _newCategoryController.clear();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF03624C),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),

              _buildInputField(
                label: "Title",
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "e.g. Spotify",
                    border: InputBorder.none,
                  ),
                  validator: (v) => v!.isEmpty ? "Enter a title" : null,
                ),
              ),

              // type dropdown
              _buildInputField(
                label: "Type",
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: _types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() {
                    _selectedType = val;
                    _selectedCategory = null; // resets category when type changes
                    if (val == 'Income') _isSubscription = false; // subscriptions are expenses
                  }),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Select Type",
                  ),
                ),
              ),

              //  date picker
              _buildInputField(
                label: "Date",
                child: GestureDetector(
                  onTap: _showDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                           "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Color(0xFF03624C),
                      ),
                    ],
                  ),
                ),
              ),

              // category dropdown
              _buildInputField(
                label: "Category",
                child: _isAddingCategory ? Row(children: [
                  Expanded(child: TextField(
                controller: _newCategoryController,
                  decoration: InputDecoration(
                    hintText: "Enter category name",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _saveNewCategory(),
                  )),
                IconButton(
                  icon: Icon(Icons.check, color: Color(0xFF03624C)),
                    onPressed: _saveNewCategory,
                  ),
                  IconButton(
                      icon: Icon(Icons.close, color: Color(0xFF03624C)),
                      onPressed: () {
                        setState((){
                          _isAddingCategory = false;
                          _newCategoryController.clear();
                        });
                      }),
                ]) : DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items:[
                    ...(_selectedType == 'Income'
                        ? _incomeCategories
                        : _expenseCategories)
                        .map((c) => DropdownMenuItem(value: c, child: Text(c),))
                        .toList(),
                    DropdownMenuItem<String>(
                      value: '_add_',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add a new category'),
                          Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFF03624C),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if(val == '_add_') {
                      setState((){
                        _isAddingCategory = true;
                      });
                    } else {
                      setState((){
                        _selectedCategory = val;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Select Category",
                  ),
                  validator: (val) => val == null ? "Select a category" : null,
                ),
              ),

              // amount Input
              _buildInputField(
                label: "Amount",
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "৳ ",
                    border: InputBorder.none,
                  ),
                  validator: (v) => v!.isEmpty ? "Enter amount" : null,
                ),
              ),

              //subscription toggle
              if (_selectedType == 'Expense') ...[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mark as Subscription",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _isSubscription,
                      activeColor: Color(0xFF03624C),
                      onChanged: (val) => setState(() => _isSubscription = val),
                    ),
                  ],
                ),
              ],

              // billing cycle
              if (_isSubscription && _selectedType == 'Expense')
                _buildInputField(
                  label: "Every",
                  child: TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: "Months",
                      border: InputBorder.none,
                    ),
                    onChanged: (val) => _billingCycle = int.tryParse(val) ?? 1,
                  ),
                ),

              SizedBox(height: 40),

              // save button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03624C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save Transaction",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInputField({required String label, required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFF0F5F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // logic for next payment
      DateTime? nextPaymentDate;
      if (_isSubscription) {
        nextPaymentDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month + _billingCycle,
          _selectedDate!.day,
        );
      }

      print(
        "Saving: ${_titleController.text}, Sub: $_isSubscription, Next: $nextPaymentDate",
      );
      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a date")));
    }
  }
}

