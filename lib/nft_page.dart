import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pim/UserHome/home.dart';
import 'package:pim/constant/color.dart';
import 'package:pim/models/event_model.dart';
import 'package:pim/payementPaypal.dart';
import 'package:pim/widgets/ui_helper.dart';
import 'package:pim/constant/text_style.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/event_model.dart';

class Nftpage extends StatefulWidget {
  final Event event;
  const Nftpage(this.event, {Key? key}) : super(key: key);
  @override
  _NftpageState createState() => _NftpageState();
}

class _NftpageState extends State<Nftpage>
    with TickerProviderStateMixin {
  late Event event;
  late AnimationController controller;
  late AnimationController bodyScrollAnimationController;
  late ScrollController scrollController;
  late Animation<double> scale;
  late Animation<double> appBarSlide;
  double headerImageSize = 0;
  bool isFavorite = false;
  @override
  void initState() {
    event = widget.event;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    bodyScrollAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= headerImageSize / 2) {
          if (!bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.forward();
        } else {
          if (bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.reverse();
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));

    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    ));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bodyScrollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerImageSize = MediaQuery.of(context).size.height / 2.5;
    return ScaleTransition(
      scale: scale,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildHeaderImage(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildEventTitle(),
                          UIHelper.verticalSpace(16),
                          buildAboutEvent(),
                          UIHelper.verticalSpace(16),
                          buildIDTOKEN(),
                          UIHelper.verticalSpace(16),
                          buildContactAdresse(),
                          UIHelper.verticalSpace(16),
                          buildBlockChaine(),
                          UIHelper.verticalSpace(16),

                          //...List.generate(10, (index) => ListTile(title: Text("Dummy content"))).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                child: buildPriceInfo(),
                alignment: Alignment.bottomCenter,
              ),
              AnimatedBuilder(
                animation: appBarSlide,
                builder: (context, snapshot) {
                  return Transform.translate(
                    offset: Offset(0.0, -1000 * (1 - appBarSlide.value)),
                    child: Material(
                      elevation: 2,
                      color: Theme.of(context).primaryColor,

                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    return
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: Image.asset(
          "assets/images/omkalthoum nFT.png",
          fit: BoxFit.cover,
        ),


      );
  }


  Widget buildEventTitle() {
    return Text(
      " Om kalthoum Nft ",
      style: headerStyle.copyWith(fontSize: 15),
    );
  }
  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("About", style: headerStyle),
        UIHelper.verticalSpace(),
        Text("this is one of the first NFT's available for om kolthoum concert on eventado application",
            style: subtitleStyle),
        UIHelper.verticalSpace(2),
      ],
    );
  }


  Widget buildIDTOKEN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("TOKEN ID", style: headerStyle),
        UIHelper.verticalSpace(),
        Text("105412073336139865871856758689961865379765593412174393695306829764487372865537",
            style: subtitleStyle),
        UIHelper.verticalSpace(2),
      ],
    );
  }
  Widget buildContactAdresse(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(" Contact Address", style: headerStyle),
        UIHelper.verticalSpace(),
        Text("0x495f947276749Ce646f68AC8c248420045cb7b5e",
            style: subtitleStyle),
        UIHelper.verticalSpace(2),
      ],
    );
  }
  Widget buildBlockChaine() {
    return Row(
      children: <Widget>[

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Blockchaine",
                style: subtitleStyle),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const ShapeDecoration(
              shape: StadiumBorder(), color: primaryLight),
        ),
        UIHelper.horizontalSpace(12),

        Container(
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Etherum",
                  style: monthStyle),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Price", style: subtitleStyle),
              UIHelper.verticalSpace(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "\$${event.price}",
                        style: titleStyle.copyWith(
                            color: Theme.of(context).primaryColor)),

                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("connect etherum address"),

                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  child: Text("Buy Now"),
                                  onPressed: () {
                                    var prix=event.price ;
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=> paymentPaypal(prix)
                                    ));
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Text("Buy nft "),
      )/*async {
              print(event.id);

              SharedPreferences prefs = await SharedPreferences.getInstance();
              print(prefs.getString("userId"));

              Map<String, dynamic> eventRegisterData = {
                "user_id": prefs.getString("userId"),
                "event_id": event.id,
              };

              Map<String, String> headers = {
                "Content-Type": "application/json; charset=UTF-8"
              };

              http.post(Uri.https("10.0.2.2:3000", "/eventRegister"),
                  headers: headers, body: json.encode(eventRegisterData));
            },*/

        ],
      ),
    );
  }


}