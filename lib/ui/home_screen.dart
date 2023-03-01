import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_currency_price/helpers/decimal_rounder.dart';
import 'package:digital_currency_price/models/crypto_model/crypto_data.dart';
import 'package:digital_currency_price/providers/crypto_data_provider.dart';
import 'package:digital_currency_price/providers/response_model.dart';
import 'package:digital_currency_price/ui/ui_hellper/home_page_view.dart';
import 'package:digital_currency_price/ui/ui_hellper/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageViewController = PageController(initialPage: 0);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    final cryptoProvider =
        Provider.of<CryptoDataProvider>(context, listen: false);

    cryptoProvider.getTopMarketCapData();
  }

  var defaultChoiceIndex = 0;

  final List<String> _choiceList = [
    "Top MarketCaps",
    "Top Gainers",
    "Top Losers"
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final cryptoProvider = Provider.of<CryptoDataProvider>(context);

    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const Drawer(),
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
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //page view
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
              ),
              //moving text
              SizedBox(
                width: double.infinity,
                height: 30,
                child: Marquee(
                  text: '🔊 this is place for news in application ',
                  style: textTheme.bodySmall,
                ),
              ),

              const SizedBox(height: 5),
              //elevated button
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.green[700],
                          textStyle: textTheme.bodySmall,
                        ),
                        child: const Text("buy"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.red[700],
                          textStyle: textTheme.bodySmall,
                        ),
                        child: const Text("sell"),
                      ),
                    ),
                  ],
                ),
              ),

              //choice chip
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        _choiceList.length,
                        (index) => ChoiceChip(
                          onSelected: (value) {
                            setState(() {
                              defaultChoiceIndex =
                                  value ? index : defaultChoiceIndex;

                              switch (index) {
                                case 0:
                                  cryptoProvider.getTopMarketCapData();
                                  break;
                                case 1:
                                  cryptoProvider.getTopGainersData();
                                  break;
                                case 2:
                                  cryptoProvider.getTopLosersData();
                                  break;
                              }
                            });
                          },
                          selectedColor: primaryColor,
                          label: Text(
                            _choiceList[index],
                            style: GoogleFonts.ubuntu(
                              color: defaultChoiceIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          selected: defaultChoiceIndex == index,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 500,
                child: Consumer<CryptoDataProvider>(
                    builder: (context, cryptoDataProvider, child) {
                  switch (cryptoDataProvider.state.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: 80,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.white,
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 8, bottom: 8, left: 8),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: SizedBox(
                                                width: 25,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SizedBox(
                                        width: 70,
                                        height: 49,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: SizedBox(
                                                width: 25,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      );
                    case Status.COMPLETED:
                      List<CryptoData>? model = cryptoDataProvider
                          .dataFuture.data!.cryptoCurrencyList;

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var number = index + 1;
                          var tokenId = model![index].id;

                          MaterialColor filterColor =
                              DecimalRounder.setColorFilter(
                                  model[index].quotes![0].percentChange24h);

                          var finalPrice = DecimalRounder.removePriceDecimals(
                              model[index].quotes![0].price);

                          // percent change setup decimals and colors
                          var percentChange =
                              DecimalRounder.removePercentDecimals(
                                  model[index].quotes![0].percentChange24h);

                          Color percentColor =
                              DecimalRounder.setPercentChangesColor(
                                  model[index].quotes![0].percentChange24h);
                          Icon percentIcon =
                              DecimalRounder.setPercentChangesIcon(
                                  model[index].quotes![0].percentChange24h);

                          return SizedBox(
                            height: height * 0.075,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    number.toString(),
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 15),
                                  child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      height: 32,
                                      width: 32,
                                      imageUrl:
                                          "https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) {
                                        return const Icon(Icons.error);
                                      }),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        model[index].name!,
                                        style: textTheme.bodySmall,
                                      ),
                                      Text(
                                        model[index].symbol!,
                                        style: textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      filterColor,
                                      BlendMode.srcATop,
                                    ),
                                    child: SvgPicture.network(
                                      "https://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/$tokenId.svg",
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$$finalPrice",
                                        style: textTheme.bodySmall,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          percentIcon,
                                          Text(
                                            "$percentChange%",
                                            style: GoogleFonts.ubuntu(
                                              color: percentColor,
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: 10,
                      );

                    case Status.ERROR:
                      return Text(cryptoDataProvider.state.message);

                    default:
                      return Container();
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
