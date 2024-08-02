import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/currency_converter/viewmodels/currency_viewmodel.dart';
import 'features/screens/home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyViewModel()..fetchCurrencies()..loadPreferences(),
      child: MaterialApp(
        title: 'Currency Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          hintColor: Colors.green,
          scaffoldBackgroundColor: Color(0xFF1E1E1E),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}