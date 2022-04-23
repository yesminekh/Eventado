import 'package:flutter/material.dart';
import 'package:pim/singin.out/facebook.dart';
import 'package:pim/singin.out/resset_page.dart';
import 'package:pim/singin.out/singup_page.dart';
import 'login_page.dart';

class SocialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/az.webp'),
            const SizedBox(height: 10),
            LoginForm(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text("Forget your Password ?",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Poppins-Bold",
                              letterSpacing: .6)),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Resset(),
                            ),
                          );
                        },
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 40,
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const facebook(),
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
                        SizedBox(width: 10),
                        Text(
                          'FACEBOOK',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: Colors.white,
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
                        SizedBox(width: 10),
                        const Text(
                          'GOOGLE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text("You don't have an account "),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingUp(),
                            ),
                          );
                        },
                        child: const Text(
                          "sing up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
