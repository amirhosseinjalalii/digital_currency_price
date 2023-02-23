import 'package:digital_currency_price/api/api_url_constant.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  dynamic getTopMarketCatData() async {
    var response;
    response = await Dio().get(ApiConstant.getTopMarketCatUrl);
    return response;
  }
}
