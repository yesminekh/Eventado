import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/profil_model.dart';
import '../utils/sql_helper.dart';

class Profilee extends StatefulWidget {
  @override
  _ProfileeState createState() => _ProfileeState();
}

class _ProfileeState extends State<Profilee> {
  late String _id;
  late String f_name;
  late String _username;
  late String _email;
  late SharedPreferences prefs;

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted !'),
    ));
    _refreshJournals();
  }

  late Future<bool> fetchedUser;
  Future<bool> fetchUser() async {
    prefs = await SharedPreferences.getInstance();
    f_name = prefs.getString("f_name")!;
    _username = prefs.getString("username")!;
    _email = prefs.getString("email")!;
    return true;
  }

  @override
  void initState() {
    fetchedUser = fetchUser();
    _refreshJournals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedUser,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFEDECF2),
            appBar: AppBar(
              backgroundColor: Color(0xFFEDECF2),
              elevation: 0.0,
            ),
            body: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'assets/chris.jpg',
                      child: Container(
                        height: 125.0,
                        width: 125.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(62.5),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/Avatar.PNG'))),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Text(
                      f_name,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      _username,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', color: Colors.grey),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                '24K',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'FOLLOWERS',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                '3',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Events',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                '21',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'BUCKET LIST',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                    ),
                    buildMyevents()
                  ],
                )
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Text('error'),
          );
        }
      },
    );
  }

  Widget buildMyevents() {
    return SizedBox(
      height: 500,
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  color: const Color(0xFFEDECF2),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    leading: Text((_journals[index]['description'])
                        .toString()
                        .substring(11, 16)),
                    title: Text(_journals[index]['title']),
                    subtitle: Text((_journals[index]['description'])
                        .toString()
                        .substring(0, 10)),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
