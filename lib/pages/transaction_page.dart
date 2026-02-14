import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  String? _selectedType;
  String? _selectedCategory;
  DateTime? _selectedDate;

  void _showDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
    ).then((value){
      if(value != null){
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }
  
  String _formateDate(DateTime date){
    return "${date.day}/${date.month}/${date.year}";
  }

  final List<String> _selectAType = ['Income', 'Expense'];

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
      ),
      body: Form(
        key: formState,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ Text(
                    'Type',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 78),
                  Container(
                    height: 70,
                    width: 244,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                    color: Color(0xFFF0F5F3),
                  ),
                  child: Center(
                    child: DropdownButtonFormField<String>(
                      hint: Text('Select a type', style: TextStyle(color: Colors.black26, fontSize: 16),),
                      items: _selectAType
                          .map<DropdownMenuItem<String>>((String value){
                        return DropdownMenuItem<String>(value: value, child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value){
                        setState((){
                          _selectedType = value;
                          if(_selectedType == 'Expense'){
                            _selectedCategory = _expenseCategories.first;
                          }
                          else{
                            _selectedCategory = _incomeCategories.first;
                          }
                        });
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Select a type';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      isExpanded: true,
                      elevation: 0,
                    ),
                  )
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(
                  'Date',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 78),
                Container(
                  height: 70,
                  width: 244,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F5F3),
                  ),
                  child: MaterialButton(
                    onPressed: _showDatePicker,
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(
                        _selectedDate == null ? "Select date" : _formateDate(_selectedDate!),
                        style: TextStyle(color: _selectedDate == null ? Colors.black26 : Colors.black, fontSize: 16),),
                        Icon(Icons.calendar_today, color: Color(0xFF03624C), size: 20,),
                      ],
                    ),
                  )
                )
                ],
              ),

              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(
                    'Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 30),
                  Container(
                      height: 70,
                      width: 244,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F5F3),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          hint: Text('Select a category', style: TextStyle(color: Colors.black26, fontSize: 16),),
                          items: (_selectedType == 'Income'? _incomeCategories : _expenseCategories)
                              .map<DropdownMenuItem<String>>((String value){
                                return DropdownMenuItem<String>(value: value, child: Text(value),);
                              }).toList(),
                          onChanged: (String?value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Select a category';
                            }
                            return null;},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          isExpanded: true,
                          elevation: 0,
                        ),
                      ),
                  ),
                  ]
                ),
              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ Text(
                    'Amount',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                                return null;},
                              decoration: InputDecoration(
                                hint: Text('0.00',style: TextStyle(color: Colors.black26, fontSize: 16),),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical:12),
                              ),
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
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
                  'Note',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                  SizedBox(width: 78),
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
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hint: Text('Add a note...', style: TextStyle(color: Colors.black26, fontSize: 16),),
                                contentPadding: EdgeInsets.symmetric(vertical:12),
                                border: InputBorder.none,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if(formState.currentState!.validate()){
                      print('Transaction details saved');
                      Navigator.pop(context);
                    }},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03624C),
                      foregroundColor: Color(0xFFF0F5F3),
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.normal,)
                  ),
                  child: Text('Save'),
                ),
              ),
              SizedBox(height: 20),
              ]
          ),
        ),
      ),
    );
  }
}


