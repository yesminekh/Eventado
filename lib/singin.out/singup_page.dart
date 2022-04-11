import 'package:flutter/material.dart';
import 'package:pim/UserHome/home.dart';
import 'package:pim/singin.out/facebook.dart';
import '../main.dart';
import 'avatr_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SingUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEDECF2),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Register Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const Text(
              "Complete your details or continue \nwith social media",
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 40,
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => facebook(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: const Color(0xFF576dff),
                      padding: const EdgeInsets.all(13),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.facebook),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: Color.fromARGB(255, 255, 255, 255),
                        padding: const EdgeInsets.all(13),
                        textStyle: const TextStyle(
                          color: Colors.black,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.jpg',
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            SinupForm(),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}

class SinupForm extends StatefulWidget {
  @override
  _SinupFormFormState createState() => _SinupFormFormState();
}

class _SinupFormFormState extends State<SinupForm> {
  var _obscureText = true;

  late String? _f_name;
  late String? _username;
  late String? _email;
  late String? _pwd;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  border: UnderlineInputBorder(),
                  labelText: "Full Name",
                  labelStyle: TextStyle(
                    color: color,
                  ),
                ),
                onSaved: (String? value) {
                  _f_name = value;
                },
                validator: (String? value) {
                  if (value!.isEmpty || value.length < 5) {
                    return "Too short !";
                  } else {
                    return null;
                  }
                }),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.email),
                border: UnderlineInputBorder(),
                labelText: "Your Email",
                labelStyle: TextStyle(
                  color: color,
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
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.face),
                  labelText: "Choose your UserName",
                  labelStyle: TextStyle(
                    color: color,
                  ),
                  border: UnderlineInputBorder()),
              onSaved: (String? value) {
                _username = value;
              },
              validator: (String? value) {
                if (value!.isEmpty || value.length < 4) {
                  return "Too short !";
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelStyle: TextStyle(
                  color: color,
                ),
                labelText: 'Password',
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
              ),
              onSaved: (String? value) {
                _pwd = value;
              },
              validator: (String? value) {
                if (value!.isEmpty || value.length < 5) {
                  return "Too Short !";
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 35),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelStyle: TextStyle(
                  color: color,
                ),
                labelText: 'ConfirmPassword',
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
              ),
            ),
            const SizedBox(
              height: 20,
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Map<String, dynamic> userData = {
                    "f_name": _f_name,
                    "email": _email,
                    "username": _username,
                    "password": _pwd,
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };
                  http
                      .post(Uri.https("eventado.herokuapp.com", "/user"),
                          headers: headers, body: json.encode(userData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvatarPage(),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("An error has occurred. Try Again"),
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
