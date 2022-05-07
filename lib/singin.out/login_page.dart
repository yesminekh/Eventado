import 'package:flutter/material.dart';

import '../main.dart';
import '../UserHome/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _obscureText = true;
  late String? _email;
  late String? _password;

  final String _baseUrl = "eventado.herokuapp.com";
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Your Email',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onSaved: (String? value) {
                _email = value;
              },
              validator: (String? value) {
                RegExp regex = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (value!.isEmpty || !regex.hasMatch(value)) {
                  return "Invalid Email !";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                labelText: 'Password',
                suffixIcon: IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.visibility,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              onSaved: (String? value) {
                _password = value;
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 13,
                ),
              ),
              child: const Text(
                'CONFIRM',
              ),
              onPressed: () {
                if (_keyForm.currentState!.validate()) {
                  _keyForm.currentState!.save();

                  Map<String, dynamic> userData = {
                    "email": _email,
                    "password": _password
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };

                  http
                      .post(Uri.https("eventado.herokuapp.com", "/user/login"),
                          headers: headers, body: json.encode(userData))
                      .then((http.Response response) async {
                    if (response.statusCode == 200) {
                      Map<String, dynamic> userData =
                          json.decode(response.body);

                      //sharedpreferances
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("token", userData["token"]);
                      prefs.setString("userId", userData["UserId"]);
                      prefs.setString("username", userData["username"]);
                      prefs.setString("f_name", userData["f_name"]);
                      prefs.setString("email", _email!);
                      print(prefs.getString("userId"));
                      print(prefs.getString("username"));
                      print(prefs.getString("f_name"));
                      print(prefs.getString("email"));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    } else if (response.statusCode == 403) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Try again"),
                              content: Text("Incorrect credentials!"),
                            );
                          });
                    } else if (response.statusCode == 201) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("email not verified!"),
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
    );
  }
}
