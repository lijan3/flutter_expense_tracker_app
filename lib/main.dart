import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blueGrey,
);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onPrimary,
        ),
      ),
      home: const Expenses(),
    ),
  );
}
