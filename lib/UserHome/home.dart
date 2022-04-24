import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:pim/drawer_widgets/messages.dart';
import 'package:pim/event_detail_page.dart';

import 'package:pim/widgets/home_bg_color.dart';
import '../constant/text_style.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';
import '../utils/app_utils.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/nearby_event_card.dart';
import '../widgets/ui_helper.dart';
import '../widgets/upcoming_event_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

late int _currentIndex = 0;
const List<Widget> _interfaces = const [MyHomePage()];

late Future<bool> _fetchedEvents;

Future<bool> fetchEvents() async {
  http.Response response =
      await http.get(Uri.https("eventado.herokuapp.com", "/event"));

  List<dynamic> eventsFromServer = json.decode(response.body);
  for (int i = 0; i < eventsFromServer.length; i++) {
    upcomingEvents.add(Event(
        id: eventsFromServer[i]["_id"],
        description: eventsFromServer[i]["description"],
        eventDate: eventsFromServer[i]["date"],
        image: eventsFromServer[i]["Affiche"],
        location: 'Tunisia',
        name: eventsFromServer[i]["name"],
        organizer: eventsFromServer[i]["organizer"],
        price: eventsFromServer[i]["Price"]));
  }
  print(eventsFromServer);

  return true;
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late ScrollController scrollController;
  late AnimationController controller;
  late AnimationController opacityController;
  late Animation<double> opacity;

  void viewEventDetail(Event event) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: EventDetailPage(event),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    opacityController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1));
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: opacityController,
    ));
    scrollController.addListener(() {
      opacityController.value = offsetToOpacity(
          currentOffset: scrollController.offset,
          maxOffset: scrollController.position.maxScrollExtent / 2);
    });
    super.initState();

    _fetchedEvents = fetchEvents();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          HomeBackgroundColor(opacity),
          SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSearchAppBar(),
                UIHelper.verticalSpace(16),
                buildUpComingEventList(),
                UIHelper.verticalSpace(16),
                buildNearbyConcerts(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomePageButtonNavigationBar(
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Messages()));
        },
        child: Badge(
          badgeContent: const Text('12'),
          child: const Icon(Icons.message_outlined),
        ),
      ),
    );
  }

  Widget buildSearchAppBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  Widget buildUpComingEventList() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Upcoming Events",
              style: headerStyle.copyWith(color: Colors.white)),
          UIHelper.verticalSpace(16),
          SizedBox(
            height: 300,
            child: FutureBuilder(
                future: _fetchedEvents,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: upcomingEvents.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final event = upcomingEvents[index];
                        return UpComingEventCard(
                            event: event, onTap: () => viewEventDetail(event));
                      },
                    );
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyConcerts() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text("Near by Concerts", style: headerStyle),
              const Spacer(),
              const Icon(Icons.more_horiz),
              UIHelper.horizontalSpace(16),
            ],
          ),
          ListView.builder(
            itemCount: nearbyEvents.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              final event = nearbyEvents[index];
              var animation = Tween<double>(begin: 800.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / nearbyEvents.length) * index, 1.0,
                      curve: Curves.decelerate),
                ),
              );
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(animation.value, 0.0),
                  child: NearbyEventCard(
                    event: event,
                    onTap: () => {},
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
