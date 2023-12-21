import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx){
    print('Constructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('CreateState NewTransaction Widget');
    return _NewTransactionState();}
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  _NewTransactionState() {
    print('Constructor NewTransaction State');
  }
  @override
  void initState() {
    print('InitState()');
    super.initState();
  }
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _submitData == null ) {
      return;
    }
    if (_amountController.text.isEmpty) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  DateTime _selectedDate = DateTime.now()  ;

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now())
        .then(
          (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate=pickedDate;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  label:  Text('Title'),
                  hintText: 'Enter title',
                ),
                keyboardType: TextInputType.text,
                // onChanged: (value) => titleText = value,
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitData(), // used to press add transaction button on pressing enter
              ),
              TextField(
                decoration: const InputDecoration(
                  label:  Text('Amount'),
                  hintText: 'Enter amount',
                ),
                keyboardType: TextInputType.number,
                // onChanged: (value) => amountText = value,
                controller: _amountController,
                onSubmitted: (_) => _submitData,
              ),
              Container(
                child: Row(children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date Chosen'
                        : 'Selected Date: ${DateFormat.yMEd().format(_selectedDate)}'),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    _submitData();
                  },
                  child: const Text(
                    'Add Transaction',
                    style:  TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
