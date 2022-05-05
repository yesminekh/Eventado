import 'package:flutter/material.dart';
import 'package:pim/widgets/ui_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/text_style.dart';
import 'event_detail.dart';

class EventInfo extends StatelessWidget {
  final String _name;
  final String _date;
  final String _description;
  final String _price;
  final String _organizer;
  final String _Affiche;

  const EventInfo(this._name, this._date, this._description, this._price,
      this._organizer, this._Affiche);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("eventName", _name);
          prefs.setString("eventDate", _date);
          prefs.setString("eventDescription", _description);
          prefs.setString("eventPrice", _price);
          prefs.setString("eventOrg", _organizer);
          prefs.setString("eventImage", _Affiche);

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ProductDetails();
          }));
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.network(_Affiche, width: 100, height: 94),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_date.toString().substring(0, 10), style: monthStyle),
                UIHelper.verticalSpace(8),
                Text(_name, style: titleStyle),
                UIHelper.verticalSpace(8),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time_outlined),
                    UIHelper.horizontalSpace(4),
                    Text(_date.toString().substring(11, 16) + " PM",
                        style: subtitleStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
