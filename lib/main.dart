import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();

  final Map<String, double> _ratesToMdl = const {
    'MDL': 1.0,
    'EUR': 19.25,
    'USD': 17.75,
    'RON': 3.85,
    'GBP': 22.45,
  };

  String _sourceCurrency = 'MDL';
  String _targetCurrency = 'EUR';
  String _resultText = 'Introduceți suma și apăsați Conversie.';

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
        _resultText = 'Introduceți o sumă validă.';
      });
      return;
    }

    final amountInMdl = amount * _ratesToMdl[_sourceCurrency]!;
    final convertedAmount = amountInMdl / _ratesToMdl[_targetCurrency]!;

    setState(() {
      _resultText =
          '${amount.toStringAsFixed(2)} $_sourceCurrency = '
          '${convertedAmount.toStringAsFixed(2)} $_targetCurrency';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencies = _ratesToMdl.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertor Valutar'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Suma',
                  hintText: 'Ex: 100',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _sourceCurrency,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Moneda sursă',
                ),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _targetCurrency,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Moneda destinație',
                ),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _convertCurrency,
                child: const Text('Conversie'),
              ),
              const SizedBox(height: 24),
              Text(
                _resultText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
