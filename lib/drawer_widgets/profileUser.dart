import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      print(_journals);
    });
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
                    SizedBox(height: 25.0),
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
                      style: TextStyle(
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
                                '31',
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
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                    ),
                    //buildImages(),
                    //buildInfoDetail(),
                    //buildImages(),
                    //buildInfoDetail(),
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
    return Container(
      height: 500,
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                      title: Text(_journals[index]['title']),
                      subtitle: Text(_journals[index]['description']),
                      trailing: const SizedBox(
                        width: 100,
                      )),
                ),
              ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add), onPressed: () => {}),
      ),
    );
  }

  Widget buildImages() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Container(
          height: 200.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: const DecorationImage(
                  image: AssetImage('assets/images/Capture.PNG'),
                  fit: BoxFit.cover))),
    );
  }

  Widget buildInfoDetail() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'om Kalthoum Metaverse',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 15.0),
              ),
              const SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  Text(
                    'Teresa Soto',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Montserrat',
                        fontSize: 11.0),
                  ),
                  SizedBox(width: 4.0),
                  const Icon(
                    Icons.timer,
                    size: 4.0,
                    color: Colors.black,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    '3 Videos',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontFamily: 'Montserrat',
                        fontSize: 11.0),
                  )
                ],
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset('assets/images/navarrow.png'),
                ),
              ),
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset('assets/images/chatbubble.png'),
                ),
              ),
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 22.0,
                  width: 22.0,
                  child: Image.asset('assets/images/fav.png'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
