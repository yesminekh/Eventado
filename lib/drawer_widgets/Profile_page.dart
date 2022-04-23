import 'package:flutter/material.dart';
import 'package:pim/UserHome/home.dart';
import 'package:pim/drawer_widgets/change-password.dart';
import 'package:pim/drawer_widgets/modifierProfile.dart';
import 'package:pim/drawer_widgets/profileUser.dart';

import 'package:pim/singin.out/social_page.dart';
import 'package:pim/widgets/bottom_navigation_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String _id;
  late String f_name;
  late String _username;
  late String _email;
  late SharedPreferences prefs;

  late Future<bool> fetchedUser;

  Future<bool> fetchUser() async {
    prefs = await SharedPreferences.getInstance();
    //_id = prefs.getString("userId")!;
    f_name = prefs.getString("f_name")!;
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
    return FutureBuilder(
      future: fetchedUser,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          int _currentIndex;
          return Scaffold(
              backgroundColor: const Color(0xFFEDECF2),
              appBar: AppBar(
                backgroundColor: const Color(0xFFEDECF2),
                title: const Text("Profile"),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()));
                  },
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Body(),
                ],
              ),
              bottomNavigationBar: HomePageButtonNavigationBar(
                onTap: (index) => setState(() => _currentIndex = index),
                currentIndex: 2,
                //currentIndex: _currentIndex,
              ));
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/Avatar.PNG"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.camera),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;

  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color.fromARGB(255, 224, 230, 245),
        ),
        onPressed: press,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 15),
          ProfileMenu(
            text: "Profile",
            icon: const Icon(Icons.person),
            press: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profilee()));
            },
          ),
          ProfileMenu(
            text: "My Account",
            icon: const Icon(Icons.account_box),
            press: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ModifierProfile()))
            },
          ),
          ProfileMenu(
            text: "Password",
            icon: const Icon(Icons.password_sharp),
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => changepaswrd()));
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: const Icon(Icons.logout),
            press: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('userId');
              prefs.remove('f_name');
              prefs.remove('username');
              prefs.remove('email');

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SocialPage()));
            },
          ),
        ],
      ),
    );
  }
}
