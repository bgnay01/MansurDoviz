import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Currency {
  final String code;
  final double buyRate;
  final double sellRate;

  Currency({required this.code, required this.buyRate, required this.sellRate});

  factory Currency.fromJson(String code, Map<String, dynamic> json) {
    return Currency(
      code: code,
      buyRate: (json['buyRate'] as num).toDouble(),
      sellRate: (json['sellRate'] as num).toDouble(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('Currencies');

  // Para birimlerinin Türkçe açılımları
  final Map<String, String> currencyDescriptions = {
    'USD': 'Amerikan Doları',
    'EUR': 'Euro',
    'EUR-USD': 'Euro / Amerikan Doları',
    'SAR': 'Suudi Arabistan Riyali',
    'AUD': 'Avustralya Doları',
    'CHF': 'İsviçre Frangı',
    'GBP': 'İngiliz Sterlini',
    'CAD': 'Kanada Doları',
    // Diğer para birimlerinin açılımlarını ekleyebilirsin
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final bottomNavBarHeight = kBottomNavigationBarHeight;
    final availableHeight = screenHeight - appBarHeight - bottomNavBarHeight;

    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: _database.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenirken hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final dynamic value = snapshot.data!.snapshot.value;
            if (value != null) {
              final Map<dynamic, dynamic> data = value as Map<dynamic, dynamic>;
              final Map<String, Currency> currencies = data.map((key, value) {
                final Map<String, dynamic> currencyData = Map<String, dynamic>.from(value);
                return MapEntry(key as String, Currency.fromJson(key as String, currencyData));
              });

              // Belirtilen dövizler (öncelikli olanlar)
              List<String> prioritizedCurrencies = ['USD', 'EUR', 'EUR-USD', 'SAR'];

              // Öncelikli dövizleri ilk sıraya, geri kalanları sona ekle
              List<Currency> sortedCurrencies = [
                ...prioritizedCurrencies
                    .where((code) => currencies.containsKey(code))
                    .map((code) => currencies[code]!),
                ...currencies.values
                    .where((currency) => !prioritizedCurrencies.contains(currency.code))
              ];

              return ListView.builder(
                itemCount: sortedCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = sortedCurrencies[index];
                  final itemHeight = availableHeight / sortedCurrencies.length;
                  final currencyDescription = currencyDescriptions[currency.code] ?? 'Bilinmeyen Para Birimi';

                  return Container(
                    height: itemHeight,
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currency.code,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5), // Açıklama ve kod arasındaki boşluk
                            Text(
                              currencyDescription, // Türkçe açılımını burada gösteriyoruz
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey, // Daha soluk bir renk kullanıyoruz
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 100, // Sabit genişlik
                                height: 50, // Sabit yükseklik
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 3), // Border kalınlığı artırıldı
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${currency.buyRate.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18, // Büyütüldü
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 100, // Sabit genişlik
                                height: 50, // Sabit yükseklik
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 3), // Border kalınlığı artırıldı
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${currency.sellRate.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18, // Büyütüldü
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Veri bulunamadı.'));
            }
          } else {
            return Center(child: Text('Veri yüklenirken bir sorun oluştu.'));
          }
        },
      ),
    );
  }
}
