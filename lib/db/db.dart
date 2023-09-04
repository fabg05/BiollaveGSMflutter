import 'package:navigation_bar_2021curso/model/contact.dart';
import 'package:navigation_bar_2021curso/model/profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'biollavegsm2.db'),
        onCreate: (db, version) {
      _createDb(db);
    }, version: 1);
  }

  static void _createDb(Database db) async {
    await db.execute(
      "CREATE TABLE profiles (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, admin INTEGER, pass TEXT, phone TEXT)",
    );
    await db.execute(
      "CREATE TABLE contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, profileid INTEGER, alias TEXT, phone TEXT)",
    );
  }

  static Future<int> insert(Profile profile) async {
    Database database = await _openDB();

    return database.insert(
      "profiles",
      {
        "nombre": profile.nombre,
        "admin": profile.admin,
        "phone": profile.phone,
        "pass": profile.pass
      },
    );
  }

  static Future<int> insertContact(Contact contact) async {
    Database database = await _openDB();
    return database.insert("contacts", contact.toMap());
  }

  static Future<int> delete(Profile profile) async {
    Database database = await _openDB();

    return database
        .delete("profiles", where: "id = ?", whereArgs: [profile.id]);
  }

  static Future<int> deleteContact(Contact contact) async {
    Database database = await _openDB();

    return database.delete("contacts",
        where: "profileid = ? and phone = ?",
        whereArgs: [contact.profileid, contact.phone]);
  }

  static Future<int> deleteContactsByProfile(Profile profile) async {
    Database database = await _openDB();

    return database
        .delete("contacts", where: "profileid = ?", whereArgs: [profile.id]);
  }

  static Future<int> deletebyname(String profileName) async {
    Database database = await _openDB();

    try {
      return database
          .delete("profiles", where: "nombre = ?", whereArgs: [profileName]);
    } catch (err) {
      // print("Something went wrong when deleting an item: $err");
    }
    return 0;
  }

  static Future<int> update(Profile profle) async {
    Database database = await _openDB();

    return database.update("profiles", profle.toMap(),
        where: "id = ?", whereArgs: [profle.id]);
  }

  static Future<List<Profile>> loadprofiles() async {
    try {
      Database database = await _openDB();
      final List<Map<String, dynamic>> profilesMap =
          await database.query("profiles");

      return List.generate(
          profilesMap.length,
          (i) => Profile(
                id: profilesMap[i]['id'],
                nombre: profilesMap[i]['nombre'],
                admin: profilesMap[i]['admin'],
                pass: profilesMap[i]['pass'],
                phone: profilesMap[i]['phone'],
              ));
    } catch (err) {
      // print("Something went wrong when deleting an item: $err");
    }
    return List.empty();
  }

  static Future<List<Contact>> loadcontacts() async {
    try {
      Database database = await _openDB();
      final List<Map<String, dynamic>> contactsMap =
          await database.query("contacts");

      return List.generate(
          contactsMap.length,
          (i) => Contact(
                id: contactsMap[i]['id'],
                profileid: contactsMap[i]['profileid'],
                alias: contactsMap[i]['alias'],
                phone: contactsMap[i]['phone'],
              ));
    } catch (err) {
      // print("Something went wrong when deleting an item: $err");
    }
    return List.empty();
  }

  static Future<List<Contact>> loadcontactsbyid(int profileid) async {
    try {
      Database database = await _openDB();
      final List<Map<String, dynamic>> contactsMap = await database
          .query("contacts", where: "profileid = ?", whereArgs: [profileid]);

      return List.generate(
          contactsMap.length,
          (i) => Contact(
                id: contactsMap[i]['id'],
                profileid: contactsMap[i]['profileid'],
                alias: contactsMap[i]['alias'],
                phone: contactsMap[i]['phone'],
              ));
    } catch (err) {
      // print("Something went wrong when deleting an item: $err");
    }
    return List.empty();
  }

  // CON SENTENCIAS
  static Future<void> insertar2(Profile profle) async {
    Database database = await _openDB();
    await database.rawInsert("INSERT INTO profiles (id, nombre, admin)"
        " VALUES (${profle.id}, ${profle.nombre}, ${profle.admin})");
  }

  static Future<void> deleteTable() async {
    Database database = await _openDB();
    await database.rawInsert("DELETE FROM profiles");
    await database
        .rawInsert("DELETE FROM sqlite_sequence WHERE name = 'profiles'");
  }

  static Future<void> deleteTableContacts() async {
    Database database = await _openDB();
    await database.rawInsert("DELETE FROM contacts");
    await database
        .rawInsert("DELETE FROM sqlite_sequence WHERE name = 'contacts'");
  }

  static Future<int> findProfile(String name) async {
    Database database = await _openDB();
    int result = Sqflite.firstIntValue(await database.rawQuery(
        "SELECT COUNT (*) FROM profiles WHERE nombre = ?", [name])) as int;
    return result;
  }

  static Future<int> getCount() async {
    Database? database = await _openDB();
    final int result = Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT (*) FROM profiles")) as int;
    return result;
  }

  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }

}
