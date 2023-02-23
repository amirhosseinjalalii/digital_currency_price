import 'package:digital_currency_price/ui/home_screen.dart';
import 'package:digital_currency_price/ui/market_view_screen.dart';
import 'package:digital_currency_price/ui/profile_screen.dart';
import 'package:digital_currency_price/ui/ui_hellper/bottom_nav.dart';
import 'package:digital_currency_price/ui/watch_list_screen.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var primaryColorLight = Theme.of(context).primaryColorLight;

    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _myPage,
        children: [
          HomeScreen(),
          MarketViewScreen(),
          ProfileScreen(),
          WatchListScreen()
        ],
      ),
      bottomNavigationBar: BottomNav(
        controller: _myPage,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: Icon(
          Icons.compare_arrows_outlined,
          color: primaryColorLight,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
