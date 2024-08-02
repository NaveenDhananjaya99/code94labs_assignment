import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/constants/api_constants.dart';
import '../models/currency_model.dart';

class CurrencyViewModel extends ChangeNotifier {
  List<CurrencyModel> _currencies = [];
  List<String> _preferredCurrencies = [];
  String _baseCurrency = 'USD';

  List<CurrencyModel> get currencies => _currencies;
  List<String> get preferredCurrencies => _preferredCurrencies;
  String get baseCurrency => _baseCurrency;

  Future<void> fetchCurrencies() async {
    final response = await http.get(Uri.parse('https://api.fastforex.io/fetch-all?from=$_baseCurrency&api_key=$key'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<CurrencyModel> loadedCurrencies = [];
      print(data);
      data['results'].forEach((code, rate) {
        print(code);
        print(rate);
        loadedCurrencies.add(CurrencyModel(
          code: code,
          name: code,
          rate: double.parse(rate.toString()),
        ));
      });

      _currencies = loadedCurrencies;
      notifyListeners();
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<void> updateCurrencyRates(String newBaseCurrency) async {
    _baseCurrency = newBaseCurrency;
    await fetchCurrencies();
    notifyListeners();
  }

  Future<void> addPreferredCurrency(String currencyCode) async {
    print(currencyCode);
    _preferredCurrencies.add(currencyCode);
    notifyListeners();
    savePreferences();
  }

  Future<void> removePreferredCurrency(String currencyCode) async {
    _preferredCurrencies.remove(currencyCode);
    notifyListeners();
    savePreferences();
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print(_preferredCurrencies);
    print(_baseCurrency);
    prefs.setStringList('preferredCurrencies', _preferredCurrencies);
    prefs.setString('baseCurrency', _baseCurrency);
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _preferredCurrencies = prefs.getStringList('preferredCurrencies') ?? [];
    _baseCurrency = prefs.getString('baseCurrency') ?? 'USD';
    await fetchCurrencies();
    notifyListeners();
  }
}
