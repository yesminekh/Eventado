class Event {
  String id;
  String name;
  String description;
  String eventDate;
  String image;
  String location;
  String organizer;
  int price;

  Event({
    required this.id,
    required this.eventDate,
    required this.image,
    required this.location,
    required this.name,
    required this.organizer,
    required this.price,
    required this.description,
  });
}

/*
final String _baseUrl = "10.0.2.2:3001";

late Future<bool> _fetchedEvents;

Future<bool> fetchEvents() async {
  http.Response response = await http.get(Uri.http(_baseUrl, "/event"));

  List<dynamic> eventsFromServer = json.decode(response.body);
  for (int i = 0; i < eventsFromServer.length; i++) {
    upcomingEvents.add(Event(
        description: eventsFromServer[i]["description"],
        eventDate: eventsFromServer[i]["date"],
        image: 'https://source.unsplash.com/800x600/?concert',
        location: 'Fairview Gospel Church',
        name: eventsFromServer[i]["name"],
        organizer: eventsFromServer[i]["organizer"],
        price: eventsFromServer[i]["price"]));
  }
  print(eventsFromServer);

  return true;
}
*/
final List<Event> upcomingEvents = [];
/*
final List<Event> upcomingEvents = [
  Event(
    name: "The Pretty Reckless",
    eventDate: DateTime.now().add(const Duration(days: 24)),
    image: 'https://source.unsplash.com/800x600/?concert',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "Fairview Gospel Church",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    name: "Live Orchestra",
    eventDate: DateTime.now().add(const Duration(days: 33)),
    image: 'https://source.unsplash.com/800x600/?band',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "David Geffen Hall",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    name: "Local Concert",
    eventDate: DateTime.now().add(const Duration(days: 12)),
    image: 'https://source.unsplash.com/800x600/?music',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "The Cutting room",
    organizer: "Westfield Centre",
    price: 30,
  ),
];*/

final List<Event> nearbyEvents = [
  Event(
    id: "1",
    name: "The Pretty Reckless",
    eventDate: "07-08-2023",
    image: 'https://source.unsplash.com/600x800/?concert',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "Fairview Gospel Church",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    id: "2",
    name: "New Thread Quartet",
    eventDate: '07-08-2023',
    image: 'https://source.unsplash.com/600x800/?live',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "David Geffen Hall",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    id: "3",
    name: "Songwriters in Concert",
    eventDate: '07-08-2023',
    image: 'https://source.unsplash.com/600x800/?orchestra',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "The Cutting room",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    id: "47",
    name: "Rock Concert",
    eventDate: '07-08-2023',
    image: 'https://source.unsplash.com/600x800/?music',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "The Cutting room",
    organizer: "Westfield Centre",
    price: 32,
  ),
  Event(
    id: "1487",
    name: "Songwriters in Concert",
    eventDate: '07-08-2023',
    image: 'https://source.unsplash.com/600x800/?rock_music',
    description:
        "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "David Field",
    organizer: "Westfield Centre",
    price: 14,
  ),
];
