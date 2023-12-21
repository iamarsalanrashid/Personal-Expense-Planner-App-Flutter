import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTx,
  });

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  '\$${widget.transaction.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  widget.deleteTx(widget.transaction.id);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  widget.deleteTx(widget.transaction.id);
                },
              ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.time)),
      ),
    );
  }
}
