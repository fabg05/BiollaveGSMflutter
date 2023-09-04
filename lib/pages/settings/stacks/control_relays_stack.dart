import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class RelayControlScreen extends StatefulWidget {
  @override
  State<RelayControlScreen> createState() => _RelayControlScreenState();
}

class _RelayControlScreenState extends State<RelayControlScreen> {
  // final Telephony telephony = Telephony.instance;
  final snackBar = SnackBar(
    content: Text('Enviando...'),
    duration: Duration(seconds: 2),
  );
  String relayNumber = 'RELAY1';
  String relayTime = '2';
  String _savedPhone = "";
  String _savedPass = "";

  String dropdownValueRelayN = "RELAY 1";
  String dropdownValueRelayTime = '2';
  String dropdownResetTime = '1h';
  String dropdownValueAcuse = 'Off';

  bool _isButtonEnabled = true;

  final relayNumberDrop = TextEditingController();
  final relayTimeDrop = TextEditingController();

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
              _buildMessageText('Ajustar tiempo enclavamiento'),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRelayNumberDrop(),
                      SizedBox(
                        width: 30,
                      ),
                      _buildRelaySecondsDrop(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildRelayTimeBtn()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildMessageText('Acuse de Recibo'),
              _buildAcuseSmsDrop(),
              SizedBox(
                height: 5,
              ),
              _buildAcuseBtn(),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildMessageText('RST Tiempo Reinicio automático'),
              _buildResetTimeDrop(),
              SizedBox(
                height: 5,
              ),
              _buildRSTBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageText(String texto) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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

  Widget _buildRelayTimeBtn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        //width: double.infinity,
        child: Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.4,
          child: ElevatedButton.icon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Ajustar $relayNumber'),
                content: Text('Tiempo a: $relayTime Seg'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      if (_isButtonEnabled) {
                        _disableButton();
                        String comando =
                            '$_savedPass%2B$relayNumber%2B$relayTime!';
                        _sendSMS(comando, recipents);
                        // telephony.sendSms(to: _savedPhone, message: comando);
                      }
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'CANCELAR');
                    },
                    child: const Text('CANCELAR'),
                  ),
                ],
              ),
            ),

            icon: Icon(
              Icons.input,
              size: 32,
            ),
            label: Text(
              'Enviar',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveBlue,
                fixedSize: Size(size.width / 3, 40),
                textStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: size.width * 0.025,
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

  Widget _buildRelayNumberDrop() {
    return DropdownButton<String>(
      value: dropdownValueRelayN,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: kBiollaveBlue),
      underline: Container(
        height: 2,
        color: kBiollaveBlue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValueRelayN = newValue!;
          relayNumber = newValue;
          relayNumber = relayNumber.replaceAll(' ', '');
        });
      },
      items: <String>['RELAY 1', 'RELAY 2', 'RELAY 3', 'RELAY 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildRelaySecondsDrop() {
    return SizedBox(
      child: DropdownButton<String>(
        value: dropdownValueRelayTime,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: kBiollaveBlue),
        underline: Container(
          height: 2,
          color: kBiollaveBlue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValueRelayTime = newValue!;
            relayTime = newValue;
          });
        },
        items: <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRSTBtn() {
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
                int rstTime = 0;
                if (dropdownResetTime == '30m') {
                  rstTime = 1;
                } else {
                  String str = dropdownResetTime.substring(
                      0, dropdownResetTime.length - 1);
                  rstTime = int.parse(str) * 2;
                }
                String comando = "$_savedPass%2BRST%2B${rstTime.toString()}!";
                _sendSMS(comando, recipents);
                // telephony.sendSms(to: _savedPhone, message: comando);
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(
              Icons.restart_alt,
              size: 32,
            ),
            label: Text(
              'Enviar',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveBlue,
                fixedSize: Size(size.width / 3, 40),
                textStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: size.width * 0.025,
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

  Widget _buildResetTimeDrop() {
    return SizedBox(
      child: DropdownButton<String>(
        value: dropdownResetTime,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: kBiollaveBlue),
        underline: Container(
          height: 2,
          color: kBiollaveBlue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownResetTime = newValue!;
            relayTime = newValue;
          });
        },
        items: <String>['30m', '1h', '2h', '4h', '6h', '12h', '24h']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAcuseBtn() {
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
                int _acuse = (dropdownValueAcuse == 'On') ? 1 : 0;
                String comando = "$_savedPass%2BAcuse%2B$_acuse!";
                _sendSMS(comando, recipents);
                // telephony.sendSms(to: _savedPhone, message: comando);
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(
              Icons.sms_failed_outlined,
              size: 32,
            ),
            label: Text(
              'Enviar',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveBlue,
                fixedSize: Size(size.width / 3, 40),
                textStyle: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: size.width * 0.025,
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

  Widget _buildAcuseSmsDrop() {
    return SizedBox(
      child: DropdownButton<String>(
        value: dropdownValueAcuse,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: kBiollaveBlue),
        underline: Container(
          height: 2,
          color: kBiollaveBlue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValueAcuse = newValue!;
            relayTime = newValue;
          });
        },
        items:
            <String>['Off', 'On'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
