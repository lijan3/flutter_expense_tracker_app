import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/widgets/chart/chart.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses/expenses_list.dart';
import 'package:flutter_expense_tracker_app/models/expense.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _addExpense(Expense exp) {
    setState(() => _registeredExpenses.add(exp));
  }

  void _removeExpense(Expense exp) {
    final index = _registeredExpenses.indexOf(exp);
    setState(() => _registeredExpenses.remove(exp));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _registeredExpenses.insert(index, exp));
          },
        ),
      ),
    );
  }

  void showAddExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget noContent = const Center(
      child: Text('No expenses to show'),
    );

    print(MediaQuery.of(context).size.width);

    final children = [
      Expanded(
        child: Chart(
          expenses: _registeredExpenses,
        ),
      ),
      Expanded(
        child: _registeredExpenses.isEmpty
            ? noContent
            : ExpensesList(
                expenses: _registeredExpenses,
                removeExpense: _removeExpense,
              ),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          actions: [
            IconButton(
              onPressed: showAddExpense,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: const Column(
          children: [Text('Column')],
        ));
  }
}
