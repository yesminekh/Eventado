import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:http/http.dart' as http;
import 'package:pim/UserHome/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../drawer_widgets/Profile_page.dart';
import '../main.dart';

class facebook extends StatefulWidget {
  const facebook({Key? key}) : super(key: key);

  @override
  State<facebook> createState() => _facebookState();
}

class _facebookState extends State<facebook> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfisLoggedIn();
  }

  _checkIfisLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    setState(() {
      _checking = false;
    });

    if (accessToken != null) {
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    } else {
      _login();
    }
  }

  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      _checking = false;
    });
  }

  _logout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(_userData);
    return MaterialApp(
      home: Scaffold(
        body: _checking
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _userData != null
                        ? Text('Name: ${_userData!['name']}')
                        : Container(),
                    _userData != null
                        ? Text('Email: ${_userData!['email']}')
                        : Container(),
                    _userData != null
                        ? Image.network(_userData!['picture']['data']['url'])
                        : Container(),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: color,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 125,
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'CONTINUE',
                      ),
                      onPressed: () {
                        Map<String, dynamic> userData = {
                          "f_name": _userData!['name'],
                          "email": _userData!['email'],
                          "username": _userData!['name'],
                          "password": "12345678",
                        };

                        Map<String, String> headers = {
                          "Content-Type": "application/json; charset=UTF-8"
                        };
                        http
                            .post(Uri.https("eventado.herokuapp.com", "/user"),
                                headers: headers, body: json.encode(userData))
                            .then((http.Response response) async {
                          if (response.statusCode == 201) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Profile(),
                              ),
                            );
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("username", _userData!['name']);
                            prefs.setString("f_name", _userData!['name']);
                            prefs.setString("email", _userData!['email']);
                            print(prefs.getString("username"));
                            print(prefs.getString("f_name"));
                            print(prefs.getString("email"));

                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return const AlertDialog(
                                    title: Text("Information"),
                                    content: Text(
                                        "Before joining us , please verify your email and a password!"),
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return const AlertDialog(
                                    title: Text("Information"),
                                    content: Text(
                                        "An error has occurred. Try Again"),
                                  );
                                });
                          }
                        });
                      },
                    ),
                    CupertinoButton(
                        color: color,
                        child: Text(
                          _userData != null ? 'LOGOUT' : 'LOGIN',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: _userData != null ? _logout : _login)
                  ],
                ),
              ),
      ),
    );
  }
}
