import 'package:flutter/material.dart';
import 'package:pim/singin.out/social_page.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  var _obscureText = true;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String? _email;
  late String? _passwd;

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
            vertical: 100,
            horizontal: 30,
          ),
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                const Text(
                  "Please Finish the process",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Your Email",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 10, 9, 9),
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.4),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
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
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "Enter Your New Password",
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
                    border: const UnderlineInputBorder(
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
                    _passwd = value;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "Comfirm Your Password",
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
                    border: const UnderlineInputBorder(
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
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();
                      Map<String, dynamic> userData = {
                        "email": _email,
                        "password": _passwd
                      };
                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };

                      http
                          .patch(
                              Uri.https("eventado.herokuapp.com",
                                  "/user/editPassword"),
                              headers: headers,
                              body: json.encode(userData))
                          .then((http.Response response) async {
                        if (response.statusCode == 200) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text("success"),
                                  content: Text("Password updated!"),
                                );
                              });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SocialPage()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text("Failed"),
                                  content: Text("Try Again!"),
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
