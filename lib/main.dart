import 'package:digital_currency_price/providers/crypto_data_provider.dart';
import 'package:digital_currency_price/providers/market_view_provider.dart';
import 'package:digital_currency_price/providers/theme_provider.dart';
import 'package:digital_currency_price/ui/main_wrapper.dart';
import 'package:digital_currency_price/ui/ui_hellper/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => CryptoDataProvider()),
      ChangeNotifierProvider(create: (context) => MarketViewProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        themeMode: themeProvider.themeMode,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const Directionality(
          textDirection: TextDirection.ltr,
          child: MainWrapper(),
        ),
      );
    });
  }
}
