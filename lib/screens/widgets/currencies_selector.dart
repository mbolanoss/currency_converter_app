import 'package:currency_converter_app/providers/currencies_provider.dart';
import 'package:currency_converter_app/screens/widgets/swap_button.dart';
import 'package:currency_converter_app/screens/widgets/widgets.dart';
import 'package:currency_converter_app/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CurrenciesSelectors extends StatefulWidget {
  @override
  State<CurrenciesSelectors> createState() => _CurrenciesSelectorsState();
}

class _CurrenciesSelectorsState extends State<CurrenciesSelectors> {
  List<String> currenciesList = [''];
  String selectedValueFrom = '';
  String selectedValueTo = '';

  void buttonOnTapAction() {
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: false);
    setState(() {
      String tempProvider = currenciesProvider.selectedOptionFrom;
      currenciesProvider.setSelectedOptionFrom =
          currenciesProvider.selectedOptionTo;
      currenciesProvider.setSelectedOptionTo = tempProvider;

      String temp = this.selectedValueFrom;
      this.selectedValueFrom = this.selectedValueTo;
      this.selectedValueTo = temp;
    });
  }

  @override
  void initState() {
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: false);
    _fillCurrenciesList(currenciesProvider);
    super.initState();
  }

  void _fillCurrenciesList(CurrenciesProvider currenciesProvider) async {
    this.currenciesList = await currenciesProvider.getCurrenciesList();

    currenciesProvider.selectedOptionFrom = this.currenciesList[0];
    currenciesProvider.selectedOptionTo = this.currenciesList[0];

    this.selectedValueFrom = currenciesProvider.selectedOptionFrom;
    this.selectedValueTo = currenciesProvider.selectedOptionTo;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle(fontSize: 25.0, text: 'From'),
        _getDropdown('from'),
        Padding(
          padding: kIsWeb
              ? EdgeInsets.symmetric(vertical: screenSize.height * 0.03)
              : EdgeInsets.symmetric(vertical: 10),
          child: Center(child: SwapButton(this.buttonOnTapAction)),
        ),
        Subtitle(fontSize: 25.0, text: 'To'),
        _getDropdown('to'),
      ],
    );
  }

  DropdownButton _getDropdown(String valuesType) {
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: true);

    final size = MediaQuery.of(context).size;

    return DropdownButton(
      //!Sensible a plataforma
      menuMaxHeight: kIsWeb ? size.height * 0.4 : size.height * 0.6,
      dropdownColor: AppColors.background1,
      items: _getDropdownMenuItems(this.currenciesList),
      value:
          valuesType == 'from' ? this.selectedValueFrom : this.selectedValueTo,
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          if (valuesType == 'from') {
            currenciesProvider.setSelectedOptionFrom = value.toString();
            this.selectedValueFrom = currenciesProvider.selectedOptionFrom;
          } else {
            currenciesProvider.setSelectedOptionTo = value.toString();
            this.selectedValueTo = currenciesProvider.selectedOptionTo;
          }
        });
      },
    );
  }

  List<DropdownMenuItem<String>> _getDropdownMenuItems(List<String> menuItems) {
    List<DropdownMenuItem<String>> itemsList = [];
    menuItems.forEach((val) {
      itemsList.add(
        DropdownMenuItem(
          child: BodyText(fontSize: 20.0, text: val),
          value: val,
        ),
      );
    });
    return itemsList;
  }
}
