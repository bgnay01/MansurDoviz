import 'package:flutter/material.dart';
import 'InfoPage.dart';
import 'ConverterPage.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Exchange App',
      theme: ThemeData(
        // Tema rengini belirlediğiniz RGBA (39, 39, 39) ile ayarlıyoruz
        primaryColor: const Color.fromARGB(255,167,188,197),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, // AppBar'daki yazı rengi
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          // ···
          brightness: Brightness.light,
        ),

      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ConverterPage(),
    const AlarmPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation:0.0,
        title: Row(
          children: [
            Image.asset(
              'assets/x.png', // Logo dosyanızı assets klasörüne koyduğunuzdan emin olun
              height: 70,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "MANSUR",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Döviz Ticaret A.Ş.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Kurlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: 'Çevirici',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Bilgi Alın',
          ),
        ],
      ),
    );
  }
}
