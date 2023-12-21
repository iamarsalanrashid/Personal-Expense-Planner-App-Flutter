import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transactions.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans', fontSize: 20, color: Colors.white),
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{

  final List<Transaction> _userTransactions = [
    Transaction(
        id: 'T1', price: 65.5, title: 'New Shoes', time: DateTime.now()),
    Transaction(
        id: 'T2', price: 16.75, title: 'Weekly Groceries', time: DateTime.now())
  ];

  void _addNewTransaction(
      String txTitle, double txamount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        price: txamount,
        time: DateTime.now());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  bool _showChart = false;

  startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((trx) {
      return trx.time.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);//this line means an observer/listener is set to detect the state change
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);//this method is automatically called when observer sees state changing
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);//this line means we are clearing /disposing the listener to lifecycle changing to avoid memory leaks
    super.dispose();
  }

  List<Widget> _BuildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txWidgetList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColorLight,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: TransactionList(_userTransactions, _deleteTransaction),
            )
    ];
  }

  List<Widget> _BuildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txWidgetList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txWidgetList
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar =
        // Platform.isIOS ?
        // CupertinoNavigationBar(
        //   middle: Text('Personal Expense App'),
        //   trailing: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       GestureDetector(
        //         child: Icon(CupertinoIcons.add),
        //         onTap: () => startAddNewTransaction,
        //       ),
        //     ],
        //   ),
        // )
        //     :
        AppBar(
      title: const Text('Personal Expense App'),
      actions: [
        IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );

    final txWidgetList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (isLandscape)
            ..._BuildLandscapeContent(mediaQuery, appBar, txWidgetList),
          if (!isLandscape)
            ..._BuildPotraitContent(mediaQuery, appBar, txWidgetList),
        ]),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            // navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => startAddNewTransaction(context),
                    child: const Icon(Icons.add),
                  ));
  }
}
