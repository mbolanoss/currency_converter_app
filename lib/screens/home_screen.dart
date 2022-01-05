import 'package:currency_converter_app/providers/currencies_provider.dart';
import 'package:currency_converter_app/screens/widgets/widgets.dart';
import 'package:currency_converter_app/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _conversionResult = 0.0;

  TextEditingController _inputTextController = TextEditingController();

  String _amount = '';

  bool _validAmount = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      //!Sensible a plataforma
      padding: kIsWeb
          ? EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.3,
              vertical: screenSize.height * 0.05,
            )
          : EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: AppColors.background2,
      ),
      child: ClipRRect(
        //!Sensible a plataforma
        borderRadius: kIsWeb
            ? BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : BorderRadius.circular(0),
        child: Scaffold(
          backgroundColor: AppColors.background1,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                //Cuadro del titulo
                TitleBox(),
                Container(
                  padding: kIsWeb
                      ? EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.05,
                          horizontal: screenSize.width * 0.03,
                        )
                      : EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.07,
                          horizontal: screenSize.width * 0.1,
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      Padding(
                        padding: kIsWeb
                            ? EdgeInsets.only(bottom: screenSize.height * 0.1)
                            : EdgeInsets.only(bottom: screenSize.height * 0.07),
                        child: Subtitle(
                            fontSize: 40.0, text: 'Currency\nConverter'),
                      ),

                      CurrenciesSelectors(),

                      //Amount textfield
                      Padding(
                        padding: kIsWeb
                            ? EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.07)
                            : EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.05),
                        child: _getAmountTextField(),
                      ),

                      //Convert button
                      SizedBox(
                        child: _getConvertButton(),
                        width: double.infinity,
                      ),

                      //Result text
                      Padding(
                        padding: kIsWeb
                            ? EdgeInsets.only(top: screenSize.height * 0.1)
                            : EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Subtitle(fontSize: 25.0, text: 'Result'),
                      ),
                      _getResultBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _getAmountTextField() {
    return TextField(
      controller: _inputTextController,
      style: GoogleFonts.josefinSans(fontSize: 20.0, color: AppColors.text),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: -15),
          hintText: 'Amount you want to convert',
          hintStyle: GoogleFonts.josefinSans(color: AppColors.text),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.title),
          ),
          errorText: !_validAmount ? 'Amount not valid' : null,
          errorStyle: GoogleFonts.josefinSans(fontSize: 17.0)),
      cursorColor: AppColors.button,
      keyboardType: TextInputType.number,
      onChanged: (val) {
        setState(() {
          if (double.tryParse(val) == null) {
            _validAmount = false;
          } else {
            _amount = val;
            _validAmount = true;
          }
        });
      },
    );
  }

  ElevatedButton _getConvertButton() {
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: false);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: AppColors.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Convert',
        style: GoogleFonts.josefinSans(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.background2,
        ),
      ),
      onPressed: () {
        if (!_validAmount || double.tryParse(_amount) == null) {
          _validAmount = false;
          setState(() {});
        } else {
          final fromCode =
              currenciesProvider.selectedOptionFrom.split(' - ')[0];
          final toCode = currenciesProvider.selectedOptionTo.split(' - ')[0];

          int tempAmount = int.parse(_amount);

          currenciesProvider
              .convert(from: fromCode, to: toCode, amount: tempAmount)
              .then((value) {
            setState(() {
              final double casted = double.parse(value);
              _conversionResult = casted * tempAmount;
            });
          });
        }
        FocusScope.of(context).unfocus();
      },
    );
  }

  Container _getResultBox() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '$_conversionResult',
        style: GoogleFonts.josefinSans(fontSize: 20.0, color: AppColors.text),
      ),
    );
  }
}
