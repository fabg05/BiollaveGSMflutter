import 'package:flutter/material.dart';

class ResizeProvider extends ChangeNotifier {
  String _titulo = "hola";
  String _selectedPhone = "";
  String _selectedAlias = "";
  double _espacio = 4.0;

  String get titulo => _titulo;
  String get seletedPhone => _selectedPhone;
  String get seletedAlias => _selectedAlias;
  double get espacio => _espacio;

  void cambiar() {
    _titulo = "chao";
    notifyListeners();
  }

  void selectPhone(String phone) {
    _selectedPhone = phone;
    notifyListeners();
  }

  void selectAlias(String alias) {
    _selectedAlias = alias;
    notifyListeners();
  }

  void disminuir() {
    _espacio = 7.0;
    notifyListeners();
  }

  void aumentar() {
    _espacio = 4.0;
    notifyListeners();
  }
}
