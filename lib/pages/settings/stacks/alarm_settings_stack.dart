import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class AlarmSettingsScreen extends StatefulWidget {
  @override
  State<AlarmSettingsScreen> createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  final snackBar = SnackBar(
    content: Text('Enviando...'),
    duration: Duration(seconds: 2),
  );

  // final Telephony telephony = Telephony.instance;
  double _currentSliderValue = 30;
  double startvalue = 0;
  double middlevalue = 50;
  double endvalue = 100;
  String dropdownValue = "Panico";
  String dropdownValueInputMode = "N.Abierta";
  String _savedPhone = "";
  String _savedPass = "";

  bool _isButtonEnabled = true;

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
              _buildMessageText(
                  'Tiempo en Segundos (rearmado automático y Relé)  \n\n0: Fija sin tiempo\n\n60: 1 Min (recomendado)'),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildSliderAlarmTime(),
              _buildAlarmTimeBtn(),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMessageText('Modo Relé:'),
                      _buildProfileDropAlarmR(),
                      //
                    ],
                  ),
                  _buildAlarmRBtn(),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 5,
                    thickness: 1.0,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMessageText('Entrada:'),
                      _buildProfileDropInputMode(),
                    ],
                  ),
                  _buildAlarmInputBtn()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageText(String texto) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            '$texto',
            style: TextStyle(
              color: kBiollaveOrange,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: size.width * 0.03,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // Widget _buildRangeText() {
  //   Size size = MediaQuery.of(context).size;
  //   return Column(
  //     children: [
  //       Text(
  //         '${startvalue.round().toString()} - ${endvalue.round().toString()}',
  //         style: TextStyle(
  //           color: kBiollaveBlue,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'OpenSans',
  //           fontSize: size.width * 0.026,
  //         ),
  //         textAlign: TextAlign.justify,
  //       ),
  //     ],
  //   );
  // }

  _buildSliderAlarmTime() {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 240,
      divisions: 8,
      activeColor: kBiollaveOrangeLight,
      inactiveColor: kBiollaveOrangeSuperLight,
      thumbColor: kBiollaveOrangeLight,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
          _currentSliderValue.round();
        });
      },
    );
  }

  Widget _buildAlarmInputBtn() {
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
                int _input = (dropdownValueInputMode == 'N.Abierta') ? 1 : 0;
                String comando = "$_savedPass%2BInput%2B$_input!";
                _sendSMS(comando, recipents);
                // print(comando);
                // telephony.sendSms(to: _savedPhone, message: comando);
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(
              Icons.input,
              size: 32,
            ),
            label: Text(
              'Enviar',
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveOrangeLight,
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

  Widget _buildAlarmRBtn() {
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
                title: Text('Modo de Alarma'),
                content: Text(
                    'Si selecciona: Llamada+SMS \n\nRelé 1 activará solo via sms On!\n\nLlamada activará alarma'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      if (_isButtonEnabled) {
                        _disableButton();
                        int _alarmR2 = 0;
                        if (dropdownValue == 'SMS') {
                          _alarmR2 = 1;
                        }
                        if (dropdownValue == 'Llamada+SMS') {
                          _alarmR2 = 2;
                        }
                        String comando = "$_savedPass%2BAlarmR2%2B$_alarmR2!";
                        _sendSMS(comando, recipents);
                        // print(comando);
                        // telephony.sendSms(to: _savedPhone, message: comando);
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              Icons.surround_sound,
              size: 32,
            ),
            label: Text(
              'Enviar',
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveOrangeLight,
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

  Widget _buildAlarmTimeBtn() {
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
                title: Text('Tiempo automático alarma'),
                content: Text(
                    'Tiempo de Sirena: ${_currentSliderValue.round().toString()} Seg'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      if (_isButtonEnabled) {
                        _disableButton();
                        String comando =
                            "$_savedPass%2BAlarmOn%2B${_currentSliderValue.round().toString()}!";
                        _sendSMS(comando, recipents);
                        // print(comando);
                        // telephony.sendSms(to: _savedPhone, message: comando);
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              Icons.alarm_add,
              size: 32,
            ),
            label: Text(
              'Enviar',
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBiollaveOrangeLight,
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

  Widget _buildProfileDropAlarmR() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: kBiollaveOrange),
      underline: Container(
        height: 2,
        color: kBiollaveOrangeSuperLight,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Panico', 'SMS', 'Llamada+SMS']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildProfileDropInputMode() {
    return DropdownButton<String>(
      value: dropdownValueInputMode,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: kBiollaveOrange),
      underline: Container(
        height: 2,
        color: kBiollaveOrangeSuperLight,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValueInputMode = newValue!;
        });
      },
      items: <String>['N.Abierta', 'N.Cerrada']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
