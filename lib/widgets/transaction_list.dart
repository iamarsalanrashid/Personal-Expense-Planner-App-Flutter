import 'package:flutter/material.dart';

import '../models/transactions.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');

    return //List of Transactions
        transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      Text('No transactions are added yet!',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset('assets/images/waiting.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                );
              })
            : ListView.builder(
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
                },
                itemCount: transactions.length,
              );
  }
}
