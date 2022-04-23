import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pim/drawer_widgets/Profile_page.dart';
import 'package:pim/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/size_config.dart';

class ModifierProfile extends StatefulWidget {
  @override
  State<ModifierProfile> createState() => _ModifierProfileState();
}

class _ModifierProfileState extends State<ModifierProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _id;

  late String? _f_name;
  late String? _username;
  late String? _email;
  late SharedPreferences prefs;

  final String _baseUrl = "10.0.2.2:3001";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Future<bool> fetchedUser;
  Future<bool> fetchUser() async {
    prefs = await SharedPreferences.getInstance();
    _id = prefs.getString("userId")!;
    _f_name = prefs.getString("f_name")!;
    _username = prefs.getString("username")!;
    _email = prefs.getString("email")!;

    return true;
  }

  @override
  void initState() {
    fetchedUser = fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDECF2),
        title: const Text("Informations"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Profile()));
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text("Edit your Informations", style: headingStyle),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Your account is already verified",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                const Icon(Icons.verified_user_rounded),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.06),
            Form(
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
                        if (value!.isEmpty || value.length < 8) {
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
                      if (value!.isEmpty || value.length < 5) {
                        return "Too short !";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 200,
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
                      'SAVE',
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Map<String, dynamic> userData = {
                          "f_name": _f_name,
                          "email": _email,
                          "username": _username,
                        };

                        Map<String, String> headers = {
                          "Content-Type": "application/json; charset=UTF-8"
                        };
                        http
                            .put(Uri.http(_baseUrl, "/user/$_id"),
                                headers: headers, body: json.encode(userData))
                            .then((http.Response response) {
                          if (response.statusCode == 201) {
                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return const AlertDialog(
                                    title: Text("Information"),
                                    content:
                                        Text("Profile updated successfully"),
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
                                    content: Text(
                                        "An error has occurred. Try Again"),
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
          ],
        ),
      ),
    );
  }
}
/*
class EdiImage extends StatefulWidget {
  const EdiImage({Key? key}) : super(key: key);

  @override
  _EditImageProfileState createState() => _EditImageProfileState();
}

class _EditImageProfileState extends State<EdiImage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          const Spacer(),
          image != null
              ? ClipOval(
                  child: Image.file(
                  image!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ))
              : const CircleAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage("assets/images/user.jpg"),
                ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: ((Builder) => bottomSheet()));
                },
                child: const Icon(
                  Icons.edit,
                  color: color,
                  size: 28.0,
                )),
          ),
        ],
      ),
    ); // one above another ( icon above image)
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera),
                  label: Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"))
            ],
          )
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
  }
}
*/