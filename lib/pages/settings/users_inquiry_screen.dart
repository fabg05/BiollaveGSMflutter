import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;
// import 'package:telephony/telephony.dart';

class UsersInquiryScreen extends StatefulWidget {
  @override
  State<UsersInquiryScreen> createState() => _UserInquiryScreenState();
}

class _UserInquiryScreenState extends State<UsersInquiryScreen> {
  // final Telephony telephony = Telephony.instance;
  double _currentSliderValue = 1;
  double _currentSliderValue2 = 1000;
  double startValue = 1;
  double middleValue = 50;
  double endValue = 100;
  bool _isSlider2000visible = false;
  bool _isButtonEnabled = true;
  String _savedPhone = "";
  String _savedPass = "";

  final rangeStartController = TextEditingController();
  final rangeEndController = TextEditingController();

  List<String> recipents = [];
    void _sendSMS(String message, List<String> recipents) async {
    String number = recipents.first;
    // final url = Uri.parse('sms://$number?body=$message');
    Uri url = Uri.parse('sms://$number?body=$message');
    if (Platform.isAndroid) {
      //FOR Android
      url = Uri.parse('sms://$number?body=$message');
    } else if (Platform.isIOS) {
      //FOR IOS
      url = Uri.parse('sms://$number&body=$message');
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  _disableButton() {
    setState(() {
      _isButtonEnabled = false;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  @override
  void initState() {
    _isButtonEnabled = true;
    setState(() {
      _savedPhone = globals.actualPhone;
      _savedPass = globals.actualPass;
      recipents = [_savedPhone];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMessageText('Seleccione el rango a consultar'),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildSlider1000(),
              _buildSlider2000(),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildMessageText('Teléfonos (desde - hasta):'),
              _buildConsultar50Btn(),
              _buildConsultar100Btn(),
              _buildMessageText('**Los primeros 5 son administradores'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageText(String texto) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            '$texto',
            style: kLabelStyleBlue,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  _buildSlider1000() {
    return Slider(
      value: _currentSliderValue,
      min: 1,
      max: 1000,
      divisions: 10,
      activeColor: kBiollaveBlue,
      inactiveColor: kBiollaveBlueLight,
      thumbColor: kBiollaveBlue,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
          if (_currentSliderValue == 1000) {
            _isSlider2000visible = true;
          } else {
            _isSlider2000visible = false;
          }
          _currentSliderValue.round();
          startValue = _currentSliderValue;
          middleValue = startValue + 49;
          endValue = middleValue + 50;
          //endvalue = _currentRangeValues.end + _currentSliderValue.round();
        });
      },
    );
  }

  _buildSlider2000() {
    return Visibility(
      visible: _isSlider2000visible,
      child: Slider(
        value: _currentSliderValue2,
        min: 1000,
        max: 1900,
        divisions: 9,
        activeColor: kBiollaveOrangeLight,
        inactiveColor: kBiollaveOrangeSuperLight,
        thumbColor: kBiollaveOrangeLight,
        label: _currentSliderValue2.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue2 = value;
            startValue = _currentSliderValue2;
            middleValue = startValue + 50;
            endValue = middleValue + 50;
          });
        },
      ),
    );
  }

  Widget _buildConsultar50Btn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        //width: double.infinity,
        child: Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.4,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_isButtonEnabled) {
                _disableButton();
                String comando =
                    "$_savedPass%2BUsers%2B${startValue.round().toString()}%2B${middleValue.round().toString()}!";
                _sendSMS(comando, recipents);
                // print(comando);
                // telephony.sendSms(to: _savedPhone, message: comando);
              }
            },
            icon: Icon(
              Icons.search,
              size: 32,
            ),
            label: Text(
              '${startValue.round().toString()} ${middleValue.round().toString()}',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF527DAA),
                fixedSize: Size(size.width / 2, 40),
                textStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultar100Btn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        //width: double.infinity,
        child: Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.4,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_isButtonEnabled) {
                _disableButton();
                String comando =
                    "$_savedPass%2BUsers%2B${middleValue.round().toString()}%2B${endValue.round().toString()}!";
                _sendSMS(comando, recipents);
                // print(comando);
                // telephony.sendSms(to: _savedPhone, message: comando);
              }
            },
            icon: Icon(
              Icons.search,
              size: 32,
            ),
            label: Text(
              '${middleValue.round().toString()} ${endValue.round().toString()}',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF527DAA),
                fixedSize: Size(size.width / 2, 40),
                textStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ),
    );
  }
}
