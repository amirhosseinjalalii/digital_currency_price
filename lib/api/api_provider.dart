import 'package:digital_currency_price/api/api_url_constant.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  dynamic getAllCryptoData() async {
    var response;
    response = await Dio().get(ApiConstant.getAllCryptoUrl);
    return response;
  }

  dynamic getTopMarketCatData() async {
    var response;
    response = await Dio().get(ApiConstant.getTopMarketCatUrl);
    return response;
  }

  dynamic getTopGainersData() async {
    var response;
    response = await Dio().get(ApiConstant.getTopGainersUrl);
    return response;
  }

  dynamic getTopLosersData() async {
    var response;
    response = await Dio().get(ApiConstant.getTopLosersUrl);
    return response;
  }
}
