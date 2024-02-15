import 'package:flutter/material.dart';
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
  final List<Expense> _registerExpenses = [
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
    setState(() => _registerExpenses.add(exp));
  }

  void _removeExpense(Expense exp) {
    final index = _registerExpenses.indexOf(exp);
    setState(() => _registerExpenses.remove(exp));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _registerExpenses.insert(index, exp));
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
      body: Column(
        children: [
          const Text('Chart'),
          Expanded(
            child: _registerExpenses.isEmpty
                ? noContent
                : ExpensesList(
                    expenses: _registerExpenses,
                    removeExpense: _removeExpense,
                  ),
          ),
        ],
      ),
    );
  }
}
