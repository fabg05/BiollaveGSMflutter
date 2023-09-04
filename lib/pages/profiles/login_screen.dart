import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navigation_bar_2021curso/db/db.dart';
import 'package:navigation_bar_2021curso/model/profile.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = true;
  String dropvalue = "";
  String _savedProfile = "";
  String _savedPhone = "";
  String _savedPass = "";
  int _savedId = 0;
  int _isAdmin = 1;

  bool isPassVisible = true;
  List<bool> _isAdminSelected = [true, false];

  List<Profile> perfiles = [];
  List<String> _profilesList = <String>[];

  final _formKey = GlobalKey<FormState>();
  final profileController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();

  // void _sendSMS(String message, List<String> recipents) async {
  //   String number = recipents.first;
  //   final url = Uri.parse('sms://$number?body=$message');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   }
  //   // String _result = await sendSMS(message: message, recipients: recipents)
  //   //     .catchError((onError) {
  //   //   print(onError);
  //   // });
  //   // print(_result);
  // }
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

  Future<void> setSavedId(int id) async {
    // print("saving $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('idsaved', id);
    });
  }

  Future<void> removeSavedProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
//------------ SHARE PREFERENCES -----------------------------------------------------------

  borrarTodo() async {
    await DB.deleteTable();
    await DB.deleteTableContacts();
    removeSavedProfile();
    loadandRefresh();
  }

  Future<void> deleteProfile(Profile profile) async {
    _profilesList.remove(profile.nombre);

    await DB.delete(profile);

    removeSavedProfile();

    if (_profilesList.isNotEmpty) {
      dropvalue = _profilesList.first.toString();
      setSavedProfile(_profilesList.first.toString());
    }
    loadandRefresh();
  }

  Profile getProfileId(String name) {
    Profile profileSelected =
        perfiles.firstWhere((i) => i.nombre.contains(name));
    return profileSelected;
  }

  bool profileInList(String name) {
    if (_profilesList.contains(name)) {
      return true;
    }
    return false;
  }

  Future<void> cargaPefiles() async {
    List<Profile> auxProfile = await DB.loadprofiles();

    //print(auxProfile);
    setState(() {
      perfiles = auxProfile;
    });

    _profilesList = [];

    perfiles.forEach((element) {
      _profilesList.add(element.nombre);
      // print('E:${element.nombre}');
    });

    dropvalue = (_profilesList.length > 0) ? _savedProfile : "";
  }

  Future<void> _loadfilteredProfile(String name) async {
    if (name != "") {
      List<Profile> filteredProfile =
          perfiles.where((perfiles) => perfiles.nombre == name).toList();

      if (filteredProfile.length > 0) {
        profileController.text = filteredProfile.first.nombre;
        phoneController.text = filteredProfile.first.phone;
        passController.text = filteredProfile.first.pass;
        _isAdmin = filteredProfile.first.admin;
        _savedPass = filteredProfile.first.pass;
        _savedPhone = filteredProfile.first.phone;
        _savedId = filteredProfile.first.id;
        globals.actualPhone = _savedPhone;
        globals.actualPass = _savedPass;
        globals.actualId = _savedId;
        if (_isAdmin == 1) {
          _isAdminSelected = [true, false];
          isPassVisible = true;
          globals.isAdmin = true;
        } else {
          _isAdminSelected = [false, true];
          isPassVisible = false;
          globals.isAdmin = false;
        }
      }
    }
    //await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      loading = false;
    });
  }

  Future<void> loadandRefresh() async {
    try {
      profileController.text = "";
      phoneController.text = "";
      passController.text = "";
      getSavedProfile().whenComplete(() {
        cargaPefiles().whenComplete(() {
          _loadfilteredProfile(_savedProfile);
        });
      });
    } catch (e) {

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

  @override
  void initState() {
    super.initState();
    loadandRefresh();
  }

  Widget _buildLogoImage() {
    Size size = MediaQuery.of(context).size;
    return Container(
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

  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Telefono',
          style: kLabelStyleBlue,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
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
              counterText: "",
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDrop2() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '',
          style: kLabelStyleBlue,
        ),
        SizedBox(height: 10.0),
        RefreshIndicator(
          onRefresh: cargaPefiles,
          child: Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyleOrange,
              width: size.width / 1.2,
              height: 50.0,
              //fixedSize: Size(size.width / 4, 40),
              child: DropdownButtonFormField(
                dropdownColor: kBiollaveOrangeLight,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  hintText: 'Nombre de Perfil',
                  hintStyle: kHintTextStyle,
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                isExpanded: true,
                onChanged: (value) {
                  Profile auxProfile = getProfileId(value.toString());
                  setState(() {
                    dropvalue = value.toString(); //AQUI ESTABA EL ERROR
                    setSavedProfile(dropvalue);
                    setSavedId(auxProfile.id);
                    _loadfilteredProfile(value.toString());
                  });
                },
                onSaved: (value) {
                  setState(() {
                    value = value.toString();
                  });
                },
                items: _profilesList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                value: dropvalue,
                hint: Text(
                  'Seleccionar',
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildProfileTF() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Perfil',
          style: kLabelStyleBlue,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          width: size.width / 1.2,
          height: 50.0,
          child: TextFormField(
            controller: profileController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if ((value!.indexOf(' ') >= 0) || value.isEmpty) {
                return "Agregar nombre de perfil sin espacios";
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
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Nombre de Perfil',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyleBlue,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          width: size.width / 1.2,
          height: 50.0,
          child: TextFormField(
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: passController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if ((value!.length < 6)) {
                return "Ingrese 6 digitos";
              } else {
                return null;
              }
            },
            obscureText: false,
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
              hintText: '123456',
              counterText: "",
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              if (passController.text.length==6)
              {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewProfileBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          profileController.text = "";
          phoneController.text = "";
          passController.text = "";
        },
        // padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Crear Nuevo',
          style: TextStyle(
              color: Color(0xFF608EC6),
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: size.width * 0.03),
        ),
      ),
    );
  }

  Widget _buildAboutBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          showAboutDialog(
            context: context,
            applicationIcon: _buildLogoImage(),
            applicationName: 'Biollave GSM',
            applicationVersion: '2.0',
            applicationLegalese: '©2021 Biollave.com',
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                      'App de control para Módulos de acceso y alarma Biollave GSM.'))
            ],
          );
        },
        // padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Acerca de...',
          style: TextStyle(
              color: Color(0xFF608EC6),
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: size.width * 0.03),
        ),
      ),
    );
  }

  Widget _buildPermissionBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () async {
          var status = await Permission.sms.status;
          if (status.isGranted) {
            // print('Permisos concedidos');
          } else if (status.isDenied) {
            if (await Permission.sms.request().isGranted) {
              // print('Permisos configurados');
            }
          }
        },
        // padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Ajustar permisos',
          style: TextStyle(
              color: Color(0xFF608EC6),
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: size.width * 0.03),
        ),
      ),
    );
  }

  Widget _buildSendAdminBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          String comando = "$_savedPass%2BAdmin!";
          if (_savedPhone.length > 9) {
            List<String> phone = [_savedPhone];
            _sendSMS(comando, phone);
          }
        },
        // padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Enviar Admin',
          style: TextStyle(
              color: Color(0xFF608EC6),
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: size.width * 0.03),
        ),
      ),
    );
  }

  // Widget _buildRememberMeCheckbox() {
  //   return Container(
  //     height: 20.0,
  //     child: Row(
  //       children: <Widget>[
  //         Theme(
  //           data: ThemeData(unselectedWidgetColor: Colors.white),
  //           child: Checkbox(
  //             value: _rememberMe,
  //             checkColor: Colors.green,
  //             activeColor: Colors.white,
  //             onChanged: (value) {
  //               setState(() {
  //                 _rememberMe = value;
  //               });
  //             },
  //           ),
  //         ),
  //         Text(
  //           'Remember me',
  //           style: kLabelStyle,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSaveBtn() {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      //width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_formKey.currentState!.validate()) {
            if (profileInList(profileController.text) == false) {
              DB.insert(Profile(
                  id: 0,
                  nombre: profileController.text,
                  admin: _isAdmin,
                  pass: passController.text,
                  phone: phoneController.text));

              setSavedProfile(profileController.text);
              getSavedProfile();
              cargaPefiles().whenComplete(() {
                Profile auxProfile = getProfileId(profileController.text);
                setSavedId(auxProfile.id);
                _savedPhone = phoneController.text;
                _savedPass = passController.text;
              });

              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(''),
                  content:
                      Text("Perfil ${profileController.text} ha sido creado!"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              Profile auxProfile = getProfileId(profileController.text);
              // print('auxId:${auxProfile.id}');

              DB.update(Profile(
                  id: auxProfile.id,
                  nombre: profileController.text,
                  admin: _isAdmin,
                  pass: passController.text,
                  phone: phoneController.text));

              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(''),
                  content: Text(
                      "Perfil ${profileController.text} ha sido Actualizado"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        // setSavedProfile(profileController.text);
                        // getSavedProfile();
                        cargaPefiles();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          } else {
            // print('Error en datos');
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Error en datos'),
                content: Text("Revisar datos ingresados!"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        icon: Icon(
          Icons.save,
          size: 32,
        ),
        label: Text(
          'Guardar',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF527DAA),
            fixedSize: Size(size.width / 3, 40),
            textStyle: TextStyle(
              //decorationColor: Colors.green,
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  Widget _buildDeleteBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      //width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Borrar perfil'),
            content: Text(
                "Borrar perfil ${profileController.text}, Pos: ${_profilesList.indexOf(profileController.text)} ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancelar'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  Profile auxProfile = getProfileId(profileController.text);
                  deleteProfile(auxProfile);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),

        onLongPress: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Borrado'),
            content: const Text(
                'Desea eliminar todos los perfiles y datos asociados?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancelar'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  borrarTodo();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),

        icon: Icon(
          Icons.delete,
          size: 32,
        ),
        label: Text(
          'Borrar',
          softWrap: false,
        ),
        //child: Text('Guardar'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            //shadowColor: Colors.white,
            foregroundColor: Color(0xFF527DAA),
            fixedSize: Size(size.width / 3, 40),
            textStyle: TextStyle(
              letterSpacing: 1.5,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    );
  }

  Widget _buildAdminToggle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      //width: double.infinity,
      child: ToggleButtons(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Admin',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Estandar',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],

        isSelected: _isAdminSelected,

        onPressed: (int newIndex) {
          setState(() {
            for (int index = 0; index < _isAdminSelected.length; index++) {
              if (index == newIndex) {
                _isAdminSelected[index] = true;
                isPassVisible = false;
                _isAdmin = 0;
                // print("Es estandar");
              } else {
                _isAdminSelected[index] = false;
                isPassVisible = true;
                _isAdmin = 1;
              }
            }
          });
        },
        selectedColor: Colors.blue,
        color: Colors.blue,
        fillColor: Colors.white,

        renderBorder: false,
        splashColor: Colors.white,
        highlightColor: Colors.orange,
        borderColor: Colors.blue.shade300,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: loading
              ? _buildLoadingImage()
              : Stack(
                  children: <Widget>[
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey.shade100
                        // decoration: BoxDecoration(
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Color(0xFFFFFFFF),
                        //       Color(0xFFbfd1e8),
                        //       Color(0xFF7fa4d1),
                        //       Color(0xFF608EC6),
                        //     ],
                        //     stops: [0.1, 0.4, 0.7, 0.9],
                        //   ),
                        // ),
                        ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        //physics: AlwaysScrollableScrollPhysics(),
                        physics: BouncingScrollPhysics(),
                        //reverse: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 60.0,
                        ),
                        // padding: EdgeInsets.only(
                        //     bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildLogoImage(),
                              SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAdminToggle(),
                                ],
                              ),
                              SizedBox(height: 10.0),

                              _buildProfileDrop2(),

                              SizedBox(height: 10.0),
                              _buildProfileTF(),
                              SizedBox(height: 10.0),
                              _buildPhoneTF(),
                              SizedBox(height: 10.0),
                              Visibility(
                                  visible: isPassVisible,
                                  child: _buildPasswordTF()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildSendAdminBtn(),
                                  _buildNewProfileBtn(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildDeleteBtn(),
                                  _buildSaveBtn(),
                                ],
                              ),
                              _buildPermissionBtn(),
                              _buildAboutBtn(),
                              //_buildSignInWithText(),
                              // _buildSocialBtnRow(),
                              //_buildSignupBtn(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
