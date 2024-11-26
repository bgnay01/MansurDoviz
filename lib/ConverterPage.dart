import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'USD';
  double _conversionResult = 0.0;

  final Map<String, double> _currencyRates = {};

  @override
  void initState() {
    super.initState();
    _fetchCurrencyRates();
  }

  void _fetchCurrencyRates() async {
    final DatabaseReference database = FirebaseDatabase.instance.ref().child('Currencies');
    final DatabaseEvent event = await database.once();

    final dynamic value = event.snapshot.value;
    if (value != null) {
      final Map<dynamic, dynamic> data = value as Map<dynamic, dynamic>;
      final Map<String, double> rates = {};

      data.forEach((key, value) {
        final Map<String, dynamic> currencyData = Map<String, dynamic>.from(value);
        final double buyRate = (currencyData['buyRate'] as num).toDouble();
        rates[key as String] = buyRate;
      });

      setState(() {
        _currencyRates.clear();
        _currencyRates.addAll(rates);
        _selectedCurrency = _currencyRates.keys.first;
      });
    }
  }
  void _convertCurrency() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final double rate = _currencyRates[_selectedCurrency] ?? 1.0;

    setState(() {
      _conversionResult = amount * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double imageHeight = constraints.maxHeight * 0.35; // Adjust this value as needed

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: imageHeight,
                  child: Image.asset('assets/converter.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Döviz Çevirici\'ye Hoşgeldiniz',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tutarı yazın ve çevirmek istediğiniz para birimini seçin.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _currencyRates.isEmpty ? null : _selectedCurrency,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCurrency = newValue!;
                          });
                        },
                        items: _currencyRates.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tutarı Girin',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _convertCurrency,
                  child: const Text('Çevir'),
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedCurrency == 'EUR-USD'
                      ? 'Sonuç: ${_conversionResult.toStringAsFixed(4)}'
                      : 'Sonuç: ${_conversionResult.toStringAsFixed(4)} TL',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}
