import 'package:flutter/material.dart';

class MarketViewScreen extends StatefulWidget {
  const MarketViewScreen({super.key});

  @override
  State<MarketViewScreen> createState() => _MarketViewScreenState();
}

class _MarketViewScreenState extends State<MarketViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("market view screen"),
      ),
    );
  }
}
