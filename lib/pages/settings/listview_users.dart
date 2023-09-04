import 'package:flutter/material.dart';
import 'package:navigation_bar_2021curso/db/db.dart';
import 'package:navigation_bar_2021curso/model/contact.dart';
import 'package:navigation_bar_2021curso/provider/resize_provider.dart';
import 'package:navigation_bar_2021curso/utilities/constants.dart';
import 'package:navigation_bar_2021curso/globals.dart' as globals;
import 'package:provider/src/provider.dart';

class ListViewUsersScreen extends StatefulWidget {
  const ListViewUsersScreen({Key? key}) : super(key: key);
  @override
  State<ListViewUsersScreen> createState() => _ListViewUsersScreen();
}

class _ListViewUsersScreen extends State<ListViewUsersScreen> {
  List<Contact> contactos = [];
  List<Contact> filteredcontactos = [];
  int _savedId = 0;

  Future<void> cargaContactos(int id) async {
    List<Contact> auxContacts = await DB.loadcontactsbyid(id);
    setState(() {
      contactos = auxContacts;
      filteredcontactos = contactos;
    });
  }

  @override
  void initState() {
    setState(() {
      _savedId = globals.actualId;
      cargaContactos(_savedId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Lista usuarios"),
        backgroundColor: kBiollaveBlue,
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredcontactos.length,
              itemBuilder: (context, index) {
                final item = filteredcontactos[index].alias;
                return Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(item),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      String selectedAliasAux = filteredcontactos[index].alias;
                      String selectedPhoneAux = filteredcontactos[index].phone;

                      context
                          .read<ResizeProvider>()
                          .selectAlias(selectedAliasAux);
                      context
                          .read<ResizeProvider>()
                          .selectPhone(selectedPhoneAux);

                      contactos.removeAt(index);
                      Navigator.pop(context);
                    });
                    // Then show a snackbar.
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('$item dismissed')));
                  },
                  // Show a red background as the item is swiped away.
                  // background: Container(color: kBiollaveOrange),
                  background: Container(
                    color: kBiollaveOrange,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),

                  child: Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.people,
                              color: kBiollaveBlue,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredcontactos[index].alias,
                                style: kLabelStyleBlue,
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                filteredcontactos[index].phone,
                                style: kLabelStyleOrange,
                              ),
                            ],
                          ),
                          // TextButton(
                          //   onPressed: () {},
                          //   child: Text('Eliminar'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar",
        ),
        onChanged: (query) {
          query = query.toLowerCase();
          setState(() {
            filteredcontactos = contactos.where((i) {
              final alias = i.alias.toLowerCase();
              final phone = i.phone.toLowerCase();
              return alias.contains(query) || phone.contains(query);
            }).toList();
          });
        },
      ),
    );
  }
}
