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
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Color(0xFF26278D),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A26278D),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Suma',
                        hintText: 'Ex: 100',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _sourceCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Moneda sursă',
                        border: OutlineInputBorder(),
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
                        labelText: 'Moneda destinație',
                        border: OutlineInputBorder(),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _convertCurrency,
                      child: const Text('Conversie'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF26278D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}