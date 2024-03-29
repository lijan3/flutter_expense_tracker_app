import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final Function addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() => _selectedDate = date);
  }

  bool _validateExpense() {
    final amount = double.tryParse(_amountController.text);
    return _titleController.text.trim().isNotEmpty &&
        amount != null &&
        amount > 0 &&
        _selectedDate != null;
  }

  void _submitExpense() {
    if (_validateExpense()) {
      _addNewExpense();
      cancelNewExpense();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Validation error occurred'),
          content: const Text(
              'Please make sure you have entered a valid title, amount and date'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _addNewExpense() {
    widget.addExpense(
      Expense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
  }

  void cancelNewExpense() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              maxLength: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefixText: '\$ ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? 'No date selected'
                            : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _showDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => {
                    if (value != null)
                      {
                        setState(() => _selectedCategory = value),
                      }
                  },
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: cancelNewExpense,
                  child: const Text('Cancel'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: FilledButton(
                    onPressed: _submitExpense,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
