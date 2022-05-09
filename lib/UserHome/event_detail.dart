// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../constant/text_style.dart';
import '../utils/notification.dart';
import '../utils/size_config.dart';
import '../widgets/ui_helper.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails();

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late String _name;
  late String _date;
  late String _description;
  late String _price;
  late String _organizer;
  late String _Affiche;
  late SharedPreferences prefs;

  bool isFavorite = true;
  late Future<bool> fetchedEvents;

  Future<bool> fetchEvents() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("eventName")!;
    _date = prefs.getString("eventDate")!;
    _description = prefs.getString("eventDescription")!;
    _price = prefs.getString("eventPrice")!;
    _organizer = prefs.getString("eventOrg")!;
    _Affiche = prefs.getString("eventImage")!;

    return true;
  }

  @override
  void initState() {
    fetchedEvents = fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedEvents,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFEDECF2),
            appBar: AppBar(
              backgroundColor: Color(0xFFEDECF2),
            ),
            body: Column(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(238),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        width: double.infinity,
                        child:
                            Image.network(_Affiche, width: 460, height: 215)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Text(
                        _name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => sendNotification(
                            body: "Join the Room", title: "Eventado"),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isFavorite
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_date.toString().substring(0, 10),
                                  style: monthStyle),
                              UIHelper.verticalSpace(8),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time_outlined),
                                  UIHelper.horizontalSpace(4),
                                  Text(_date.toString().substring(11, 16) + " ",
                                      style: subtitleStyle),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        UIHelper.horizontalSpace(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_organizer, style: titleStyle),
                            UIHelper.verticalSpace(4),
                            const Text("Organizer", style: subtitleStyle),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(64),
                      ),
                      child: Text(
                        _description,
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: 10,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    UIHelper.verticalSpace(8),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      var random = Random();
                      int min = 5540;
                      int max = 5555;
                      var randomNumber = min + random.nextInt(max - min);

                      print(randomNumber);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Key coppied----" + randomNumber.toString()),
                      ));
                    },
                    child: const Text('Get Your Key')),
                AlertDialog(
                  title: Text("Key for " + _name),
                  // content: Text(a.toString()),
                ),
              ],
            ),
          );
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

class MAX {}
