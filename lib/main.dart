import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Common/db_change_notifier.dart';
import 'package:todo_app/List/list_screen.dart';

void main() {
  runApp(ChangeNotifierProvider<DbChangeNotifier>(
      create: (context) => DbChangeNotifier(),
      child: AdaptiveTheme(
          light: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.green,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          initial: AdaptiveThemeMode.dark,
          dark: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color.fromARGB(255, 3, 55, 98),
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 3, 55, 98)),
            colorScheme: const ColorScheme.dark(primary: Colors.purple),
          ),
          builder: (theme, darkTheme) => MaterialApp(
                title: "Todo App",
                theme: theme,
                darkTheme: darkTheme,
                home: const ListScreen(),
              ))));
}
