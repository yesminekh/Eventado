import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/text_style.dart';
import '../utils/notification.dart';
import '../utils/size_config.dart';
import '../widgets/ui_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  late SharedPreferences prefs;
  bool isFavorite = false;
  late Future<bool> fetchedEvents;

  Future<bool> fetchEvents() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("eventName")!;
    _date = prefs.getString("eventDate")!;
    _description = prefs.getString("eventDescription")!;
    _price = prefs.getString("eventPrice")!;
    _organizer = prefs.getString("eventOrg")!;

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
                        child: Image.asset("assets/images/Capture.PNG",
                            width: 460, height: 215)),
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
                        onTap: () => //setState(() => isFavorite = !isFavorite),
                            sendNotification(
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
