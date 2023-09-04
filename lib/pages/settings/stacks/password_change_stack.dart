import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class PassChangeScreen extends StatefulWidget {
  @override
  State<PassChangeScreen> createState() => _PassChangeScreenState();
}

class _PassChangeScreenState extends State<PassChangeScreen> {
  final snackBar = SnackBar(
    content: Text('Enviando...'),
    duration: Duration(seconds: 2),
  );

  // final Telephony telephony = Telephony.instance;
  bool _isButtonEnabled = true;
  final _formKey = GlobalKey<FormState>();
  final newpassController = TextEditingController();
  final newpass2Controller = TextEditingController();
  String _savedPhone = "";
  String _savedPass = "";

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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              _buildMessageText('Ingrese su nueva clave (6 digitos):'),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 5,
                thickness: 1.0,
              ),
              _buildNewPassTF(),
              SizedBox(
                height: 10,
              ),
              _buildNewPass2TF(),
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
              _buildEnviarNewPassBtn(),
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

  Widget _buildNewPassTF() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Telefono',
          //   style: kLabelStyle2,
          // ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 50.0,
            width: size.width / 2.5,
            child: TextFormField(
              maxLength: 6,
              controller: newpassController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.length < 6) {
                  return "Revisar";
                } else {
                  return null;
                }
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock_open,
                  color: Colors.white,
                ),
                hintText: 'Nueva',
                counterText: "",
                hintStyle: kHintTextStyle,
                errorStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPass2TF() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Telefono',
          //   style: kLabelStyle,
          // ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 50.0,
            width: size.width / 2.5,
            child: TextFormField(
              maxLength: 6,
              controller: newpass2Controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != newpassController.text) {
                  return "No coincide";
                } else {
                  return null;
                }
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Repetir',
                counterText: "",
                hintStyle: kHintTextStyle,
                errorStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnviarNewPassBtn() {
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
              if (_formKey.currentState!.validate()) {
                if (_isButtonEnabled) {
                  _disableButton();
                  String comando =
                      "$_savedPass%2BNewpass%2B${newpass2Controller.text}!";
                  _sendSMS(comando, recipents);
                  // print(comando);
                  // telephony.sendSms(to: _savedPhone, message: comando);
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
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
}
