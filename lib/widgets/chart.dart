import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions){
    print('Constructor Chart');
  }
  // To get a List of Total Sum of amount of Transactions in each day of Previous week
  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double totalSum = 0.0;
        for (int i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].time.day == weekDay.day &&
              recentTransactions[i].time.month == weekDay.month &&
              recentTransactions[i].time.year == weekDay.year) {
            totalSum += recentTransactions[i].price;
          }
        }
        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': totalSum
        };
      },
    ).reversed.toList();
  }

  // to get the amount of total spending's in the last week
  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');

    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(15),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: groupedTransactionValues.map((data) {
                  return Flexible(
                      fit: FlexFit.tight,
                      // returns a chart bar for each list value.
                      child: ChartBar(
                          data['day'],
                          data['amount'],
                          totalSpending == 0.0
                              ? 0.0
                              : (data['amount'] as double) / totalSpending));
                }).toList())));
  }
}
