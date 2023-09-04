class Contact {
  int? id;
  int profileid;
  String alias;
  String phone;

  Contact(
      {this.id,
      required this.profileid,
      required this.alias,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'profileid': profileid, 'alias': alias, 'phone': phone};
  }
}
