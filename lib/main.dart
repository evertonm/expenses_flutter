import 'package:expenses/components/chart.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData(fontFamily: 'Quicksand');
    return MaterialApp(
      home: const MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
            titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        appBarTheme: AppBarTheme(
            color: tema.colorScheme.primary,
            titleTextStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: Colors.white)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
        title: Text(
          'Despesas pessoais',
          style: TextStyle(
            fontSize: 20 * MediaQuery.textScalerOf(context).scale(1),
          ),
        ),
        actions: [
          if (isLandscape)
            IconButton(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            ),
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(Icons.add),
          ),
        ]);
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: 
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Exibir gráfico'),
                    Switch.adaptive(
                        value: _showChart,
                        onChanged: (value) {
                          setState(() {
                            _showChart = value;
                          });
                        }),
                  ],
                ), */
              if (_showChart || !isLandscape)
                SizedBox(
                  height: availableHeight * (isLandscape ? 0.8 : 0.30),
                  child: Chart(recentTransactions: _recentTransaction),
                ),
              if (!_showChart || !isLandscape)
                SizedBox(
                  height: availableHeight * (isLandscape ? 1 : 0.70),
                  child: TransactionList(
                    transactions: _transactions,
                    onRemove: _removeTransaction,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
