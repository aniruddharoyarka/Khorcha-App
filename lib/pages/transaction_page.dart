import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _selectedType = 'Income';
  String _selectedCategory = 'Salary';

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
        //centerTitle: true,
        actions: [

        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
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
                          if(_selectedType == 'Income'){
                            _selectedCategory = _incomeCategories.first;
                          }
                          else{
                            _selectedCategory = _expenseCategories.first;
                          }
                        });
                      },
                      isExpanded: true,
                       elevation: 0,
                      underline: Container(),
                      menuMaxHeight: 200,
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
                  height: 50,
                  width: 244,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F5F3),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: '0.00',
                        contentPadding: EdgeInsets.symmetric(vertical:12),
                        border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
          ]
        ),
      )
    );
  }
}


