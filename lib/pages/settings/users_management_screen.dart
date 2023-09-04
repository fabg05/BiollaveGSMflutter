import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/model/profile.dart';
import 'package:navigation_bar_2021curso/pages/settings/listview_users.dart';
import 'package:provider/provider.dart';
import 'package:navigation_bar_2021curso/db/db.dart';
import 'package:navigation_bar_2021curso/model/contact.dart';
import 'package:navigation_bar_2021curso/provider/resize_provider.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
// import 'package:telephony/telephony.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class UsersManagmentScreen extends StatefulWidget {
  @override
  State<UsersManagmentScreen> createState() => _UserManagmentScreenState();
}

class _UserManagmentScreenState extends State<UsersManagmentScreen> {
  final snackBar = SnackBar(
    content: Text('Enviando...'),
    duration: Duration(seconds: 2),
  );

  // final Telephony telephony = Telephony.instance;

  bool _isMultiNumbersVisible = false;
  bool _isBtnDeleteVisible = true;
  List<Contact> contactos = [];
  List<Profile> perfiles = [];
  String _savedPhone = "";
  String _savedPass = "";
  int _savedId = 99;
  int _selectedContact = 0;
  bool _isButtonEnabled = true;

  final _formKey = GlobalKey<FormState>();
  final aliasController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneController2 = TextEditingController();
  final phoneController3 = TextEditingController();
  final phoneController4 = TextEditingController();

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

  borrarContactos() async {
    await DB.deleteTableContacts();
  }

  Future<void> cargaContactos(int id) async {
    List<Contact> auxContacts = await DB.loadcontactsbyid(id);
    // print("selectedContact:$_selectedContact");
    setState(() {
      contactos = auxContacts;
      if (_selectedContact > 0) {
        phoneController.text = contactos[_selectedContact].phone;
      }
    });
  }

  _disableButton() {
    setState(() {
      _isButtonEnabled = false;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      _savedPhone = globals.actualPhone;
      _savedPass = globals.actualPass;
      _savedId = globals.actualId;
      _selectedContact = globals.selectedContact;
      recipents = [_savedPhone];
      cargaContactos(_savedId);
      aliasController.text = context.read<ResizeProvider>().seletedAlias;
      phoneController.text = context.read<ResizeProvider>().seletedPhone;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAliasTF(),
                      _buildMultiAddBtn(),
                    ],
                  ),
                  Row(
                    children: [_buildPhoneTF(), _buildShowContactsBtn()],
                  ),
                  _buildMultiNumbers(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDeleteBtn(),
                  _buildAgregarBtn(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomText(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAliasTF() {
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
            width: size.width / 1.2,
            child: TextFormField(
              maxLength: 12,
              controller: aliasController,
              keyboardType: TextInputType.text,
              validator: (value) {
                return null;
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.people_alt,
                  color: Colors.white,
                ),
                hintText: 'Alias (Opcional)',
                counterText: "",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTF() {
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
            width: size.width / 1.2,
            child: TextFormField(
              maxLength: 12,
              controller: phoneController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.length < 8) {
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
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: 'Telefono',
                counterText: '',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiNumbers() {
    return Visibility(
      visible: _isMultiNumbersVisible,
      child: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildPhoneTF2(),
              ],
            ),
            Row(
              children: [
                _buildPhoneTF3(),
                // SizedBox(
                //   width: 45,
                // )
              ],
            ),
            Row(
              children: [
                _buildPhoneTF4(),
                // SizedBox(
                //   width: 45,
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTF2() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            width: size.width / 1.2,
            child: TextFormField(
              maxLength: 12,
              controller: phoneController2,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.length < 8) {
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
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: 'Telefono 2',
                counterText: "",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTF3() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            width: size.width / 1.2,
            child: TextFormField(
              maxLength: 12,
              controller: phoneController3,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.length < 8) {
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
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: 'Telefono 3',
                counterText: "",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTF4() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            width: size.width / 1.2,
            child: TextFormField(
              maxLength: 12,
              controller: phoneController4,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.length < 8) {
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
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: 'Telefono 4',
                counterText: "",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBtn() {
    Size size = MediaQuery.of(context).size;
    return Visibility(
      visible: _isBtnDeleteVisible,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.4,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            //width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_isButtonEnabled) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _disableButton();
                  String numero = phoneController.text.toString().trim();
                  if (numero.isNotEmpty) {
                    DB.deleteContact(
                        Contact(profileid: _savedId, alias: "", phone: numero));
                    String comando = "$_savedPass%2BDel%2B$numero!";
                    // telephony.sendSms(to: _savedPhone, message: comando);
                    _sendSMS(comando, recipents);
                    aliasController.text = "";
                    phoneController.text = "";
                    context.read<ResizeProvider>().selectAlias("");
                    context.read<ResizeProvider>().selectPhone("");
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              icon: Icon(
                Icons.remove,
                size: 32,
              ),
              label: Text(
                'Eliminar',
                softWrap: false,
              ),
              //child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: kBiollaveOrange,
                  fixedSize: Size(size.width / 3, 40),
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
      ),
    );
  }

  Widget _buildBottomText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Se envian SMS para Agregar y Borrar'),
        // Text(''),
      ],
    );
  }

  Widget _buildAgregarBtn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.4,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_isButtonEnabled) {
                FocusManager.instance.primaryFocus?.unfocus();
                _disableButton();
                List<String> phoneList = [
                  phoneController.text.toString(),
                  phoneController2.text.toString(),
                  phoneController3.text.toString(),
                  phoneController4.text.toString()
                ];
                if (_isMultiNumbersVisible == false) {
                  if (phoneController.text.toString().isNotEmpty) {
                    DB.insertContact(Contact(
                      profileid: _savedId,
                      alias: aliasController.text,
                      phone: phoneList[0],
                    ));
                    String comando =
                        "$_savedPass%2BAdd%2B${phoneList[0].toString()}!";
                    // telephony.sendSms(to: _savedPhone, message: comando);
                    _sendSMS(comando, recipents);
                  }
                } else {
                  if (phoneController.text.toString().isNotEmpty) {
                    String comando =
                        "$_savedPass%2BAddm%2B${phoneList[0].toString()}%2B${phoneList[1].toString()}%2B${phoneList[2].toString()}%2B${phoneList[3].toString()}!";
                    _sendSMS(comando, recipents);
                    phoneList.forEach((element) {
                      if (element.isNotEmpty) {
                        DB.insertContact(Contact(
                          profileid: _savedId,
                          alias: aliasController.text,
                          phone: element,
                        ));
                      }
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            icon: Icon(
              Icons.verified_user,
              size: 32,
            ),
            label: Text(
              'Agregar',
              softWrap: false,
            ),
            //child: Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF527DAA),
                fixedSize: Size(size.width / 3, 40),
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

  Widget _buildMultiAddBtn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          //width: double.infinity,
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {
                if (_isMultiNumbersVisible == false) {
                  context.read<ResizeProvider>().disminuir();
                  _isMultiNumbersVisible = true;
                  phoneController2.clear();
                  phoneController3.clear();
                  phoneController4.clear();
                } else {
                  context.read<ResizeProvider>().aumentar();
                  _isMultiNumbersVisible = false;
                  _isBtnDeleteVisible = true;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShowContactsBtn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          //width: double.infinity,
          child: IconButton(
            icon: Icon(
              Icons.contact_phone,
              color: kBiollaveBlue,
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListViewUsersScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
