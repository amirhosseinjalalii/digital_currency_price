import 'package:digital_currency_price/ui/ui_hellper/home_page_view.dart';
import 'package:digital_currency_price/ui/ui_hellper/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController _pageViewController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: const [ThemeSwitcher()],
        title: const Text("digital currency"),
        titleTextStyle: textTheme.titleLarge,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: SizedBox(
                  height: 168,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      HomePageView(controller: _pageViewController),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SmoothPageIndicator(
                            controller: _pageViewController,
                            count: 4,
                            effect: ExpandingDotsEffect(
                              activeDotColor: primaryColor,
                              dotWidth: 10,
                              dotHeight: 10,
                            ),
                            onDotClicked: (index) =>
                                _pageViewController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
