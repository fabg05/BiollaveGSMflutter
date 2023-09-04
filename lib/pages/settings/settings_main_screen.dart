import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/model/profile.dart';
import 'package:navigation_bar_2021curso/pages/settings/stacks/alarm_settings_stack.dart';
import 'package:navigation_bar_2021curso/pages/settings/stacks/control_relays_stack.dart';
import 'package:navigation_bar_2021curso/pages/settings/stacks/password_change_stack.dart';
import 'package:navigation_bar_2021curso/pages/settings/users_inquiry_screen.dart';
import 'package:navigation_bar_2021curso/pages/settings/users_management_screen.dart';
import 'package:navigation_bar_2021curso/provider/resize_provider.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:provider/provider.dart';
// import 'package:telephony/telephony.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class SettingsMainScreen extends StatefulWidget {
  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  // final Telephony telephony = Telephony.instance;
  int _settingIndex = 0;
  final phoneController = TextEditingController();
  double _espaciodiv = 4.0;
  Color _backgroundColor = kBiollaveBlue;
  List<Profile> perfiles = [];
  List<Profile> filteredProfile = [];
  String _savedPhone = "";
  String _savedPass = "";
  bool _isButtonEnabled = true;

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
    setState(() {
      _savedPhone = globals.actualPhone;
      _savedPass = globals.actualPass;
      recipents = [_savedPhone];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _espaciodiv = context.watch<ResizeProvider>().espacio;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: _backgroundColor,
            expandedHeight: size.height / _espaciodiv,
            floating: false, pinned: false, snap: false,
            //title: Text(context.watch<ResizeProvider>().titulo),
            //title: Text("Hola!"),
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   'Hola!',
              //   style: TextStyle(color: Colors.black),
              // ),
              background: Image.asset(
                // "assets/images/configiconbiollavesmall.png",
                "assets/images/configmodule.png",
                fit: BoxFit.scaleDown,
                // color: Color(0xFF608EC6),
              ),
              // background: Image.network(
              //   'https://himdeve.eu/wp-content/uploads/2015/05/himdeve_labrador_with_cute_woman_model.jpg',
              //   fit: BoxFit.cover,
              //   // color: Color(0xFF608EC6),
              // ),
            ),
          ),
          SliverFillRemaining(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Center _buildContent() {
    return Center(
      child: Container(
        color: Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getHorizontalMenu(),
            Divider(
              thickness: 2,
              height: 1,
            ),
            Expanded(
                child: SingleChildScrollView(child: _getStackContainers())),
          ],
        ),
      ),
    );
  }

  Widget _getHorizontalMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _buildUsersBtn(),
          _buildAlarmBtn(),
          _buildStatusBtn(),
          _buildRelayBtn(),
        ],
      ),
    );
  }

  Widget _getStackContainers() {
    return IndexedStack(
      index: _settingIndex,
      children: <Widget>[
        _buildUsersStack(),
        AlarmSettingsScreen(),
        _buildStatusStack(),
        RelayControlScreen(),
        UsersManagmentScreen(),
        UsersInquiryScreen(),
        PassChangeScreen(),
      ],
    );
  }

// stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks
// stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks stacks

  Widget _buildUsersStack() {
    return Container(
      //color: Colors.blue.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUsuariosBtn(),
              _buildAdminPassBtn(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildConsultarUsuariosBtn(),
              _buildEntradaAlarmaBtn2(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStack() {
    return Container(
      //color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEstadoBtn(),
              _buildSignalBtn(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReporteBtn(),
              _buildPasswordBtn(),
            ],
          ),
        ],
      ),
    );
  }

// buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons
// buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons buttons

  Widget _buildUsersBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _settingIndex = 0;
                _backgroundColor = kBiollaveBlue;
              });
            },
            child: Text('Usuarios'),
          )
        ],
      ),
    );
  }

  Widget _buildAlarmBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _settingIndex = 1;
                _backgroundColor = kBiollaveOrange;
              });
            },
            child: Text('Alarma'),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _settingIndex = 2;
                _backgroundColor = kBiollaveBlue;
              });
            },
            child: Text('Estado'),
          )
        ],
      ),
    );
  }

  Widget _buildRelayBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _settingIndex = 3;
                _backgroundColor = kBiollaveOrange;
              });
            },
            child: Text('Control'),
          )
        ],
      ),
    );
  }

// BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO
// BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO
// BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO BOTONES DEL PANEL USUARIO

  Widget _buildUsuariosBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _settingIndex = 4;
          });
        },
        icon: Icon(
          Icons.people,
          size: 32,
        ),
        label: Text(
          'Usuarios',
          softWrap: false,
          //overflow: TextOverflow.ellipsis,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Color(0xFFffffff),
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildAdminPassBtn() {
    Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: _isButtonEnabled ? 1.0 : 0.4,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //width: double.infinity,
        child: TextButton.icon(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('AdminPass'),
              content: Text('Activa permisos para un nuevo admin!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_isButtonEnabled) {
                      _disableButton();
                      Navigator.pop(context, 'OK');
                      String comando = "$_savedPass%2BAdminPass!";
                      if (_savedPhone.isNotEmpty) {
                        _sendSMS(comando, recipents);
                        // telephony.sendSms(to: _savedPhone, message: comando);
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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
            Icons.security,
            size: 32,
          ),
          label: Text(
            'AdminPass',
            softWrap: false,
          ),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF608EC6),
              foregroundColor: Color(0xFFffffff),
              fixedSize: Size(size.width / 3, size.width / 3),
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
    );
  }

  Widget _buildConsultarUsuariosBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _settingIndex = 5;
          });
        },
        icon: Icon(
          Icons.search,
          size: 32,
        ),
        label: Text(
          'Consultar',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Color(0xFFffffff),
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildEntradaAlarmaBtn2() {
    Size size = MediaQuery.of(context).size;

    return Visibility(
      visible: true,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            // print('Delete Button Pressed');
          },
          icon: Icon(
            Icons.extension,
            size: 32,
          ),
          label: Text('Entrada N.O / N.C'),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.grey.shade200,
              fixedSize: Size(size.width / 3, size.width / 3),
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
    );
  }

// STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS
// STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS
// STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS STATUS

  Widget _buildEstadoBtn() {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_isButtonEnabled) {
            _disableButton();
            String comando = "$_savedPass%2BStatus!";
            _sendSMS(comando, recipents);
            // telephony.sendSms(to: _savedPhone, message: comando);
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        icon: Icon(
          Icons.settings,
          size: 32,
        ),
        label: Text(
          'Status',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Colors.grey.shade200,
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildSignalBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_isButtonEnabled) {
            _disableButton();
            String comando = "$_savedPass%2BSignal!";
            _sendSMS(comando, recipents);
            // telephony.sendSms(to: _savedPhone, message: comando);
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        icon: Icon(
          Icons.signal_cellular_alt,
          size: 32,
        ),
        label: Text(
          'Señal',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Colors.white,
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  // Widget _buildAcuseBtn() {
  //   Size size = MediaQuery.of(context).size;
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
  //     //width: double.infinity,
  //     child: TextButton.icon(
  //       onPressed: () {
  //         FocusManager.instance.primaryFocus?.unfocus();
  //         // print('Delete Button Pressed');
  //       },
  //       icon: Icon(
  //         Icons.sms_failed,
  //         size: 32,
  //       ),
  //       label: Text(
  //         'Acuse',
  //         softWrap: false,
  //       ),
  //       //child: Text('Guardar'),
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Color(0xFF608EC6),
  //           foregroundColor: Colors.white,
  //           fixedSize: Size(size.width / 3, size.width / 3),
  //           textStyle: TextStyle(
  //             letterSpacing: 1.5,
  //             fontSize: size.width * 0.025,
  //             fontWeight: FontWeight.bold,
  //             fontFamily: 'OpenSans',
  //           ),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10))),
  //     ),
  //   );
  // }

  Widget _buildReporteBtn() {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_isButtonEnabled) {
            _disableButton();
            String comando = "$_savedPass%2BReporte!";
            _sendSMS(comando, recipents);
            // telephony.sendSms(to: _savedPhone, message: comando);
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        icon: Icon(
          Icons.calendar_today,
          size: 32,
        ),
        label: Text(
          'Reporte',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Colors.grey.shade200,
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildPasswordBtn() {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      //width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _settingIndex = 6;
          });
        },
        icon: Icon(
          Icons.password,
          size: 32,
        ),
        label: Text(
          'Clave',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF608EC6),
            foregroundColor: Colors.grey.shade200,
            fixedSize: Size(size.width / 3, size.width / 3),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
