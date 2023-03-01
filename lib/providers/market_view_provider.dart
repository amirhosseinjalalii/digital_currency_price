import 'package:digital_currency_price/api/api_provider.dart';
import 'package:digital_currency_price/models/crypto_model/all_crypto_model.dart';
import 'package:digital_currency_price/providers/response_model.dart';
import 'package:flutter/material.dart';

class MarketViewProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();

  late AllCryptoModel dataFuture;

  late ResponseModel state;
  // ignore: prefer_typing_uninitialized_variables
  var response;

  getCryptoData() async {
    state = ResponseModel.loading("is loading");

    try {
      response = await apiProvider.getAllCryptoData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.completed(dataFuture);
      } else {
        state = ResponseModel.error("something wrong please try again");
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("please check your connection");
      notifyListeners();
    }
  }
}
