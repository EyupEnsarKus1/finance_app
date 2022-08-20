import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/model.dart';

class Repository {
  Future<PriceModel?> getPriceData() async {
    const url = "https://finfree.app/demo";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "R29vZCBMdWNr",
      },
    );

    if (response.statusCode == 200) {
      return PriceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Api Hatası");
    }
  }
}
