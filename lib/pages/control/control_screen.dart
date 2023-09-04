import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:navigation_bar_2021curso/db/db.dart';
import 'package:navigation_bar_2021curso/model/profile.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class ControlScreen extends StatefulWidget {
  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Enviando...'),
    duration: Duration(seconds: 2),
  );

  bool _loading = true;
  Color colorFondo = Color(0xFF608EC6);
  // final Telephony telephony = Telephony.instance;
  bool _isButtonEnabled = true;
  bool _isDisable1 = false;
  bool _isDisable2 = false;
  bool _isDisable3 = false;
  bool _isDisable4 = false;

  // double _barvalue = 0.0;
  List<Profile> perfiles = [];
  List<String> _profilesList = <String>[];
  List<bool> _isProfileSelected = [];
  List<Profile> filteredProfile = [];
  String _savedProfile = "";
  String _savedPhone = "";
  String _savedPass = "";
  int _isAdmin = 1;
  int _savedId = 0;

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

//------------ SHARE PREFERENCES -----------------------------------------------------------
  Future<void> getSavedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedProfile = prefs.getString('profilesaved') ?? "";
    });
    // print("Perfil guardado: $_savedProfile");
  }

  Future<void> setSavedProfile(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profilesaved', name);
    });
  }
//------------ SHARE PREFERENCES -----------------------------------------------------------

  @override
  void initState() {
    _isButtonEnabled = true;
    cargaPefiles();
    checkPermissions();
    super.initState();
  }

  _disableButton() {
    setState(() {
      _isButtonEnabled = false;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isButtonEnabled = true;
        // _barvalue = 0.0;
        _isDisable1 = false;
        (_isAdmin == 1) ? _isDisable2 = false : _isDisable2 = true;
        _isDisable3 = false;
        _isDisable4 = false;
      });
    });
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> checkPermissions() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      if (await Permission.sms.request().isGranted) {
        // print('Permisos configurados');
      }
    }
  }

  Future<void> cargaPefiles() async {
    List<Profile> auxProfile = await DB.loadprofiles();
    // print(auxProfile);
    getSavedProfile().whenComplete(() {
      setState(() {
        perfiles = auxProfile;
        _profilesList = [];

        perfiles.forEach((element) {
          _profilesList.add(element.nombre);
          (element.nombre == _savedProfile.trim())
              ? _isProfileSelected.add(true)
              : _isProfileSelected.add(false);
        });

        // print(_isProfileSelected);
        _loading = false;
      });
      _loadfilteredProfile(_savedProfile);
    });
  }

  Future<void> _loadfilteredProfile(String name) async {
    filteredProfile =
        perfiles.where((perfiles) => perfiles.nombre == name).toList();
    if (filteredProfile.isNotEmpty) {
      _isAdmin = filteredProfile.first.admin;
      _savedPass = filteredProfile.first.pass;
      _savedPhone = filteredProfile.first.phone;
      _savedId = filteredProfile.first.id;

      globals.actualPhone = _savedPhone;
      globals.actualPass = _savedPass;
      globals.actualId = _savedId;
      recipents = [_savedPhone];

      if (_isAdmin == 1) {
        globals.isAdmin = true;
        _isDisable2 = false;
      } else {
        globals.isAdmin = false;
        _isDisable2 = true;
      }
      setState(() {});
    }
  }

  Widget _buildLoadingImage() {
    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: Color(0xff608EC6),
          size: 50.0,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Scaffold(
        key: _formKey,
        //resizeToAvoidBottomInset: false,
        backgroundColor: colorFondo,
        body: _loading
            ? _buildLoadingImage()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 1.3,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.3),
                            height: 800.0,
                            decoration: new BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(24.0),
                                  topRight: const Radius.circular(24.0),
                                )),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              (_profilesList.isNotEmpty)
                                  ? _buildDynamicToggle()
                                  : _buildTopText(),
                              SizedBox(
                                height: size.height * 0.2,
                              ),
                              _buildLogoImage(),
                              SizedBox(
                                height: size.height * 0.033,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildControlBtnSOS('SOS'),
                                      _buildControlBtnR2('R2'),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _buildControlBtnAlarm('ALARM'),
                                      _buildControlBtnR1('R1'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              _buildBottomText(),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDynamicToggle() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            //width: double.infinity,
            child: ToggleButtons(
              isSelected: _isProfileSelected,
              children: _profilesList.map((String data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    data,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onPressed: (int newIndex) {
                // print(_profilesList[newIndex]);

                setSavedProfile(_profilesList[newIndex]);
                _loadfilteredProfile(_profilesList[newIndex]);
                // print(filteredProfile.first.phone);
                setState(() {
                  for (int index = 0;
                      index < _isProfileSelected.length;
                      index++) {
                    if (index == newIndex) {
                      _isProfileSelected[index] = true;
                    } else {
                      _isProfileSelected[index] = false;
                    }
                  }
                });
              },

              selectedColor: Colors.blue,
              color: Colors.blue,
              fillColor: kBiollaveOrangeLight, //Color del cuadro
              renderBorder: false,
              splashColor: Colors.blue,
              highlightColor: Colors.orange,
              borderColor: Colors.blue.shade300,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomText() {
    return Column(
      children: [
        Text('+ Acceso + Seguridad'),
        Text('2023'),
      ],
    );
  }

  Widget _buildTopText() {
    return Column(
      children: [
        Text(
          'Sin perfiles',
          style: kLabelStyle,
        ),
        Text(
          'Agregar para controlar',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildLogoImage() {
    Size size = MediaQuery.of(context).size;
    return Container(
      // width: double.infinity,
      // height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            // top: 40,
            // left: 30,
            child: Image.asset("assets/images/biollave.png",
                width: size.width * 0.18),
          ),
        ],
      ),
    );
  }

  // Widget _buildProgressBar() {
  //   return Container(
  //       alignment: Alignment.topCenter,
  //       margin: EdgeInsets.all(20),
  //       child: LinearProgressIndicator(
  //         value: _barvalue,
  //       ));
  // }

  // playLocal() async {
  //   int result = await audioPlayer.play('alarm.mp3', isLocal: true);
  // }

  Widget _buildControlBtnSOS(String funcion) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Opacity(
        opacity: _isDisable1 ? 0.4 : 1.0,
        child: ElevatedButton.icon(
          onLongPress: () {
            if (_isButtonEnabled) {
              _disableButton();
              if (_savedPhone.length > 9) {
                _sendSMS('SOS!', recipents);
              }
              setState(() {
                _isDisable1 = true;
              });
            }
          },
          onPressed: () {},
          icon: Icon(
            Icons.security_update_warning,
            size: 32,
          ),
          label: Text(
            funcion,
            softWrap: false,
          ),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: kBiollaveBlue,
              foregroundColor: Colors.white,
              fixedSize: Size(size.width / 3, 150),
              textStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(24.0),
              ))),
        ),
      ),
    );
  }

  Widget _buildControlBtnAlarm(String funcion) {
    Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: _isDisable2 ? 0.4 : 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //width: double.infinity,
        child: TextButton.icon(
          onLongPress: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Monitoreo Alarma'),
              content: const Text('Apagar o encender funciones de alarma'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OFF');
                    if (_isButtonEnabled == true && _isDisable2 == false) {
                      String comando = "$_savedPass%2BAlarmOFF!";
                      _sendSMS(comando, recipents);
                      _disableButton();
                      if (_savedPhone.length > 9) {
                        // telephony.sendSms(to: _savedPhone, message: comando);
                      }
                      setState(() {
                        _isDisable2 = true;
                      });
                    }
                  },
                  child: const Text('OFF'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ON');
                    if (_isButtonEnabled) {
                      String comando = "$_savedPass%2BAlarmOn!";
                      _disableButton();
                      if (_savedPhone.length > 9) {
                        // telephony.sendSms(to: _savedPhone, message: comando);
                        _sendSMS(comando, recipents);
                      }
                      setState(() {
                        _isDisable2 = true;
                      });
                    }
                  },
                  child: const Text('ON'),
                ),
              ],
            ),
          ),
          onPressed: () {},
          icon: Icon(
            Icons.car_rental,
            size: 32,
          ),
          label: Text(
            funcion,
            softWrap: false,
          ),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: kBiollaveBlue,
              foregroundColor: Colors.white,
              fixedSize: Size(size.width / 3, 100),
              textStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: size.width * 0.025,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                topRight: const Radius.circular(24.0),
              ))),
        ),
      ),
    );
  }

  Widget _buildControlBtnR2(String funcion) {
    Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: _isDisable3 ? 0.4 : 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            if (_isButtonEnabled) {
              // colorFondo = Colors.green;
              // print('sending ON2! to $_savedPhone');
              _disableButton();
              if (_savedPhone.length > 9) {
                // telephony.sendSms(to: _savedPhone, message: "ON2!");
                _sendSMS('ON2!', recipents);
              }
              setState(() {
                _isDisable3 = true;
              });
            }
          },
          icon: Icon(
            Icons.car_rental,
            size: 32,
          ),
          label: Text(
            funcion,
            softWrap: false,
          ),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: kBiollaveOrangeLight,
              foregroundColor: Colors.white,
              fixedSize: Size(size.width / 3, 100),
              textStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
              shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(10)
                  borderRadius: new BorderRadius.only(
                //topLeft: const Radius.circular(24.0),
                //topRight: const Radius.circular(24.0),
                bottomLeft: const Radius.circular(24.0),
              ))),
        ),
      ),
    );
  }

  Widget _buildControlBtnR1(String funcion) {
    Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: _isDisable4 ? 0.4 : 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        //width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            setState(() {
              if (_isButtonEnabled) {
                // colorFondo = Colors.grey;
                _disableButton();
                if (_savedPhone.length > 9) {
                  _sendSMS('ON!', recipents);
                }
                setState(() {
                  _isDisable4 = true;
                });
              }
            });
          },

          onLongPress: () async {
            if (_isButtonEnabled) {
              // bool? res =
              //     await FlutterPhoneDirectCaller.callNumber(_savedPhone);
              final Uri url = Uri(
                scheme: 'tel',
                path: _savedPhone,
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          },

          icon: Icon(
            Icons.car_rental,
            size: 32,
          ),
          label: Text(
            funcion,
            softWrap: false,
          ),
          //child: Text('Guardar'),
          style: ElevatedButton.styleFrom(
              backgroundColor: kBiollaveBlue,
              foregroundColor: Colors.white,
              fixedSize: Size(size.width / 3, 150),
              textStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
              shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(10)
                  borderRadius: new BorderRadius.only(
                //topLeft: const Radius.circular(24.0),
                //topRight: const Radius.circular(24.0),
                //bottomLeft: const Radius.circular(24.0),
                bottomRight: const Radius.circular(24.0),
              ))),
        ),
      ),
    );
  }
}
