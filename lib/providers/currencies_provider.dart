import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CurrenciesProvider extends ChangeNotifier {
  String selectedOptionFrom = '1';
  String selectedOptionTo = '1';

  bool optionsAssignedFrom = false;
  bool optionsAssignedTo = false;

  String get getSelectedOptionFrom {
    return this.getSelectedOptionFrom;
  }

  String get getSelectedOptionTo {
    return this.getSelectedOptionTo;
  }

  set setSelectedOptionFrom(String option) {
    selectedOptionFrom = option;
    notifyListeners();
  }

  set setSelectedOptionTo(String option) {
    selectedOptionTo = option;
    notifyListeners();
  }

  Future<List<String>> getCurrenciesList() async {
    List<String> currenciesList = [];

    final url = Uri.parse(
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json');
    final response = await http.get(url);
    final Map<String, dynamic> currenciesResult = jsonDecode(response.body);

    currenciesList.clear();

    currenciesResult.forEach((key, value) {
      currenciesList.add('${key.toUpperCase()} - $value');
    });
    currenciesList.sort();
    return currenciesList;
  }

  Future<String> convert({
    required String from,
    required String to,
    required int amount,
  }) async {
    final url = Uri.parse(
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/${from.toLowerCase()}/${to.toLowerCase()}.json');
    final response = await http.get(url);

    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse['${to.toLowerCase()}'].toString();
  }
}
