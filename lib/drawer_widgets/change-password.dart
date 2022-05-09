import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

import 'Profile_page.dart';

class changepaswrd extends StatefulWidget {
  @override
  _changepaswrdState createState() => _changepaswrdState();
}

class _changepaswrdState extends State<changepaswrd> {
  var _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _id;

  late String? _actualpassd;
  late String? _newpassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 100,
            horizontal: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Your password",
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onSaved: (String? value) {
                      _actualpassd = value;
                    },
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "please enter your actual password !";
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "New password",
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onSaved: (String? value) {
                      _newpassword = value;
                    },
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "Too short !";
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "confirm password",
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: color,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'CONFIRM',
                  ),
                  onPressed: () async {
                    print(_id);
                    late SharedPreferences prefs;
                    prefs = await SharedPreferences.getInstance();
                    _id = prefs.getString("userId")!;
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Map<String, dynamic> userData = {
                        "password": _newpassword,
                      };
                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };
                      http
                          .put(
                              Uri.https(
                                  "eventado.herokuapp.com", "/user/" + _id!),
                              headers: headers,
                              body: json.encode(userData))
                          .then((http.Response response) {
                        if (response.statusCode == 201) {
                          showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return const AlertDialog(
                                  title: Text("Information"),
                                  content:
                                      Text("Password updated successfully"),
                                );
                              });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Profile(),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return const AlertDialog(
                                  title: Text("Information"),
                                  content:
                                      Text("An error has occurred. Try Again"),
                                );
                              });
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
