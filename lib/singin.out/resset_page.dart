import 'package:flutter/material.dart';
import 'package:pim/main.dart';
import 'package:pim/singin.out/newpsw_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Resset extends StatelessWidget {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String? _email;

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
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Column(
            children: [
              const Text(
                "Resset Password",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  "Please enter your address email to reset your password "),
              const SizedBox(height: 20),
              Form(
                key: _keyForm,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: const Icon(Icons.email),
                    hintText: "Your Email",
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    border: const UnderlineInputBorder(
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
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 120,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'SEND',
                ),
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();

                    Map<String, dynamic> userData = {
                      "email": _email,
                    };
                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };

                    http
                        .post(
                            Uri.https("eventado.herokuapp.com",
                                "/user/forgotPassword"),
                            headers: headers,
                            body: json.encode(userData))
                        .then((http.Response response) async {
                      if (response.statusCode == 200) {
                        Map<String, dynamic> userData =
                            json.decode(response.body);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewPassword()));
                      } else if ((response.statusCode == 401)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text("Try Again"),
                                content: Text(
                                    "The email address undefined is not associated with any account. Check your email address and try again"),
                              );
                            });
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
