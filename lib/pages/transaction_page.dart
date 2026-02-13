import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  String _selectedType = 'Expense';
  String _selectedCategory = 'Food';

  void _showDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
    );
  }

  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Business', 'Investment', 'Rental', 'Gift', 'Refund', 'Other'];

  final List<String> _expenseCategories = ['Food', 'Grocery', 'Internet', 'Transport', 'Shopping', 'Entertainment', 'Rent', 'Utilities', 'Healthcare', 'Education', 'Travel', 'Other'];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      appBar: AppBar(
        title: Text(
          'Add transaction',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        actions: [
          MaterialButton(
            onPressed: _showDatePicker,
            child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.calendar_today, color: Color(0xFF03624C), size: 20,),
                )
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Form(
            key: formState,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  children: <Widget>[
                  SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ Text(
                'Type',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                ),
              ),
                SizedBox(width: 78),
                Container(
                  height: 50,
                  width: 244,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F5F3),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedType,
                    items: ['Income','Expense']
                        .map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(value: value, child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String?value){
                      setState((){
                        _selectedType = value!;
                        if(_selectedType == 'Expense'){
                          _selectedCategory = _expenseCategories.first;
                        }
                        else{
                          _selectedCategory = _incomeCategories.first;
                        }
                      });
                    },
                    isExpanded: true,
                    elevation: 0,
                    underline: Container(),
                  ),
                ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ Text(
                    'Amount',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                    SizedBox(width: 45),
                    Container(
                      height: 70,
                      width: 244,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F5F3),
                      ),
                      child: Row(
                        children: [
                          Text('৳ ',style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "Enter an amount";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical:12),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ Text(
                    'Category',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                    SizedBox(width: 30),
                    Container(
                      height: 50,
                      width: 244,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F5F3),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        items: (_selectedType == 'Income'? _incomeCategories : _expenseCategories)
                            .map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(value: value, child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String?value){
                          setState((){
                            _selectedCategory = value!;
                          });
                        },
                        isExpanded: true,
                        elevation: 0,
                        underline: Container(),
                      ),
                    ),
                  ]
              ),
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [ Text(
                          'Note',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                          SizedBox(width: 78),
                          Container(
                            height: 50,
                            width: 244,
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF0F5F3),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Add a note...',
                                contentPadding: EdgeInsets.symmetric(vertical:12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ]
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                            if(formState.currentState!.validate()){
                              print('Transaction details saved');
                              Navigator.pop(context);
                            }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF03624C),
                            foregroundColor: Color(0xFFF0F5F3),
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            )
                        ),
                        child: Text('Save'),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]
              ),
            ),
          ),
      ),
    );
  }
}


