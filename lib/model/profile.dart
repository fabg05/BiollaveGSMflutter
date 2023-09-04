class Profile {
  int id;
  String nombre;
  int admin;
  String pass;
  String phone;

  Profile(
      {required this.id,
      required this.nombre,
      required this.admin,
      required this.pass,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'admin': admin,
      'pass': pass,
      'phone': phone
    };
  }
}
