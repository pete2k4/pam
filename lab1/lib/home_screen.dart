import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();

  final Map<String, double> _ratesToMdl = const {
    'MDL': 1.0,
    'USD': 17.75,
    'EUR': 19.25,
    'RON': 3.85,
    'GBP': 22.45,
  };

  String _sourceCurrency = 'MDL';
  String _targetCurrency = 'USD';
  String _result = 'Rezultatul va apărea aici';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convertCurrency() {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (amount == null || amount < 0) {
      setState(() {
        _result = 'Introduceți o sumă validă';
      });
      return;
    }

    final amountInMdl = amount * _ratesToMdl[_sourceCurrency]!;
    final convertedAmount = amountInMdl / _ratesToMdl[_targetCurrency]!;

    setState(() {
      _result = '${convertedAmount.toStringAsFixed(2)} $_targetCurrency';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencies = _ratesToMdl.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),

          DropdownButtonFormField<String>(
            initialValue: _sourceCurrency,
            items: currencies
                .map(
                  (currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _sourceCurrency = value;
              });
            },
          ),

          DropdownButtonFormField<String>(
            initialValue: _targetCurrency,
            items: currencies
                .map(
                  (currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _targetCurrency = value;
              });
            },
          ),

          ElevatedButton(
            onPressed: _convertCurrency,
            child: const Text('Conversie'),
          ),

          Text(_result),
        ],
      ),
    );  }
}