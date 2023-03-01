import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_currency_price/models/crypto_model/crypto_data.dart';
import 'package:digital_currency_price/providers/market_view_provider.dart';
import 'package:digital_currency_price/providers/response_model.dart';
import 'package:digital_currency_price/ui/ui_hellper/shimmer_market_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/decimal_rounder.dart';

class MarketViewScreen extends StatefulWidget {
  const MarketViewScreen({super.key});

  @override
  State<MarketViewScreen> createState() => _MarketViewScreenState();
}

class _MarketViewScreenState extends State<MarketViewScreen> {
  late Timer timer;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    final cryptoProvider =
        Provider.of<MarketViewProvider>(context, listen: false);

    cryptoProvider.getCryptoData();

    timer = Timer.periodic(const Duration(seconds: 20),
        (Timer t) => cryptoProvider.getCryptoData());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;
    var borderColor = Theme.of(context).secondaryHeaderColor;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        titleTextStyle: textTheme.titleLarge,
        title: const Text("market view"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(child: Consumer<MarketViewProvider>(
              builder: (context, marketViewProvider, child) {
                switch (marketViewProvider.state.status) {
                  case Status.LOADING:
                    return const ShimmerMarketWidget();

                  case Status.COMPLETED:
                    List<CryptoData>? model =
                        marketViewProvider.dataFuture.data!.cryptoCurrencyList;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "search",
                              hintStyle: textTheme.bodySmall,
                              prefixIcon: Icon(
                                Icons.search,
                                color: borderColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primary,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: borderColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: model!.length,
                            itemBuilder: (context, index) {
                              var number = index + 1;
                              var tokenId = model[index].id;
                              var finalPrice =
                                  DecimalRounder.removePriceDecimals(
                                model[index].quotes![0].price,
                              );

                              Icon percentIcon =
                                  DecimalRounder.setPercentChangesIcon(
                                model[index].quotes![0].percentChange24h,
                              );

                              Color percentColor =
                                  DecimalRounder.setPercentChangesColor(
                                model[index].quotes![0].percentChange24h,
                              );
                              var percentChange =
                                  DecimalRounder.removePercentDecimals(
                                model[index].quotes![0].percentChange24h,
                              );

                              MaterialColor filterColor =
                                  DecimalRounder.setColorFilter(
                                model[index].quotes![0].percentChange24h,
                              );

                              return SizedBox(
                                height: height * 0.075,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        number.toString(),
                                        style: textTheme.bodySmall,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                        left: 10,
                                      ),
                                      child: CachedNetworkImage(
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        height: 32,
                                        width: 32,
                                        imageUrl:
                                            "https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png",
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.white,
                                          child: SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model[index].name!,
                                            style: textTheme.bodySmall,
                                            overflow: TextOverflow.ellipsis,
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
                                            filterColor, BlendMode.srcATop),
                                        child: SvgPicture.network(
                                          "https://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/$tokenId.svg",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(finalPrice),
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
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );

                  case Status.ERROR:
                    return Text(marketViewProvider.state.message);

                  default:
                    return Container();
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
