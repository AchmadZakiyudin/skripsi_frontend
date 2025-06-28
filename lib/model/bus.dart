import 'package:booking_bus/model/user.dart';

class Bus {
  String? id;
  String? title;
  String? image;
  String? location;
  String? description;
  double? rating;
  int? price;
  String? type;
  int? users;
  List<String>? facilities;
  User? owner;

  Bus({
    this.description,
    this.facilities,
    this.id,
    this.image,
    this.location,
    this.owner,
    this.price,
    this.rating,
    this.title,
    this.type,
    this.users,
  });

  get harga => null;
}

final listbusTop = [
  Bus(
    description:
        "An bus is a private residence in a building or house that's divided into several separate dwellings. An bus can be one small room or several. An bus is a flat — it's usually a few rooms that you rent in a building.",
    facilities: ['4 Bedrooms', '1 Toilet'],
    id: 'bus1',
    image: 'asset/bus1.png',
    location: 'Bali, Indonesia',
    owner: listUser[0],
    price: 230,
    rating: 4.5,
    title: 'Bus Pertiwi',
    type: 'Hot this month',
    users: 13,
  ),
  Bus(
    description:
        "An bus is a private residence in a building or house that's divided into several separate dwellings. An bus can be one small room or several. An bus is a flat — it's usually a few rooms that you rent in a building.",
    facilities: ['2 Bedrooms', '1 Toilet', '1 Living Room', '1 Kitchen'],
    id: 'bus2',
    image: 'asset/bus2.png',
    location: 'Garut, Indonesia',
    owner: listUser[1],
    price: 173,
    rating: 4.5,
    title: 'Bus Garuda',
    type: 'Great Place',
    users: 40,
  ),
];
final listBusNear = [
  Bus(
    description:
        "An Bus is a private residence in a building or house that's divided into several separate dwellings. An Bus can be one small room or several. An Bus is a flat — it's usually a few rooms that you rent in a building.",
    facilities: ['2 Bedrooms', '1 Toilet', '1 Living Room', '1 Kitchen'],
    id: 'bus3',
    image: 'asset/bus3.png',
    location: 'Bandung, Indonesia',
    owner: listUser[2],
    price: 221,
    rating: 4.5,
    title: 'Valley Mount',
    type: 'Pure',
    users: 39,
  ),
  Bus(
    description:
        "An Bus is a private residence in a building or house that's divided into several separate dwellings. An Bus can be one small room or several. An Bus is a flat — it's usually a few rooms that you rent in a building.",
    facilities: ['2 Bedrooms', '1 Toilet', '1 Living Room', '1 Kitchen'],
    id: 'bus4',
    image: 'asset/bus4.png',
    location: 'Garut, Indonesia',
    owner: listUser[1],
    price: 180,
    rating: 4.5,
    title: 'Loa Uhuy',
    type: 'Pure',
    users: 21,
  ),
];
