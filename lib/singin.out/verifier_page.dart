import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../delayedAnimation.dart';
import '../main.dart';
import '../UserHome/home.dart';
import 'package:http/http.dart' as http;

import '../utils/notification.dart';

class Verifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            vertical: 200,
            horizontal: 30,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: const Text("Please enter your verification code here"),
              ),
              const SizedBox(height: 35),
              VerifierForm(),
              const SizedBox(height: 35),
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
                  String? token = "";
                  print(token);
                  var prefs = await SharedPreferences.getInstance();
                  token = prefs.getString("token");
                  print(token);
                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };
                  http
                      .get(
                          Uri.https("eventado.herokuapp.com",
                              "/user/confirmation/" + token!),
                          headers: headers)
                      .then((http.Response response) async {
                    if (response.statusCode == 200) {
                      sendNotification(
                          body: "Your account has been verified",
                          title: "Welcome");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    } else if (response.statusCode == 401) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Try again"),
                              content: Text("User not found, please sign up."),
                            );
                          });
                    } else if (response.statusCode == 400) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text(
                                  "The confirmation link expired, please reverify."),
                            );
                          });
                    }
                  });
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 35),
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                          child: DelayedAnimation(
                        delay: 6500,
                        child: Text("Didn't recieve the code  "),
                      )),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            Map<String, String> headers = {
                              "Content-Type": "application/json; charset=UTF-8"
                            };
                          },
                          child: const DelayedAnimation(
                            delay: 6500,
                            child: Text(
                              "Re_send",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}

class VerifierForm extends StatefulWidget {
  @override
  _VerifierFormState createState() => _VerifierFormState();
}

class _VerifierFormState extends State<VerifierForm> {
  final _text = TextEditingController();
  final bool _validate = false;
  @override
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: ".",
                labelStyle: TextStyle(
                  color: Colors.grey[400],
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
              keyboardType: TextInputType.number,
            ),
          ),
          const Expanded(
              child: SizedBox(
            width: 20,
          )),
          Expanded(
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                hintText: ".",
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
                labelStyle: TextStyle(
                  color: Colors.grey[400],
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
              keyboardType: TextInputType.number,
            ),
          ),
          const Expanded(
              child: SizedBox(
            width: 15,
          )),
          Expanded(
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
                hintText: ".",
                labelStyle: TextStyle(
                  color: Colors.grey[400],
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
              keyboardType: TextInputType.number,
            ),
          ),
          const Expanded(
              child: SizedBox(
            width: 20,
          )),
          Expanded(
            child: TextField(
              controller: _text,
              decoration: InputDecoration(
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
                hintText: ".",
                labelStyle: TextStyle(
                  color: Colors.grey[400],
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
              keyboardType: TextInputType.number,
            ),
          )
        ],
      ),
    );
  }
}
