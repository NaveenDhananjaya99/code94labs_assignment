import 'package:code94labs_assignment/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons/main_button_design.dart';
import '../currency_converter/viewmodels/currency_viewmodel.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCurrency;
  List<String> _converters = [];

  @override
  Widget build(BuildContext context) {
    final currencyViewModel = Provider.of<CurrencyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Exchanger'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INSERT AMOUNT:',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:AppColors.boxDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: AppColors.textWhite),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  hint: Text(
                    _selectedCurrency ?? 'Select',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                  value: _selectedCurrency,
                  dropdownColor:AppColors.dropdown ,
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                  items: currencyViewModel.currencies.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency.code,
                      child: Text(
                        currency.code,
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'CONVERT TO:',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _converters.length,
                itemBuilder: (context, index) {
                  final preferredCurrencyCode = _converters[index];
                  final preferredCurrency = currencyViewModel.currencies.firstWhere(
                        (currency) => currency.code == preferredCurrencyCode,

                  );

                  // Handle case where the preferred currency is not found
                  if (preferredCurrency == null) {
                    return ListTile(
                      title: Text(
                        'Currency not found',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final amount = double.tryParse(_amountController.text) ?? 0;
                  final convertedAmount = amount * preferredCurrency.rate;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color:AppColors.boxDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              convertedAmount.toStringAsFixed(2),
                              style: TextStyle(color: AppColors.textWhite, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        DropdownButton<String>(
                          value: preferredCurrency.code,
                          dropdownColor:AppColors.dropdown ,
                          onChanged: (value) {
                            setState(() {
                              _converters[index] = value!;
                            });
                          },
                          items: currencyViewModel.currencies.map((currency) {
                            return DropdownMenuItem<String>(
                              value: currency.code,
                              child: Text(
                                currency.code,
                                style: TextStyle(color: AppColors.textWhite),
                              ),
                            );
                          }).toList(),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _converters.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: MainElevatedButton(
                onPressed: () {
                  if (_selectedCurrency != null) {
                    setState(() {
                      _converters.add(_selectedCurrency!);
                    });
                  }
                },
                text: '+ ADD CONVERTER',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
