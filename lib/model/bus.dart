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
        "Bus pariwisata semesta melaju menuju destinasi impian. Dengan kenyamanan kursi rebah dan sistem pendingin terbaru, perjalanan panjang menjadi pengalaman menyenangkan. Jetbus 5 membawa setiap penumpang pada petualangan tak terlupakan. Di balik kemudi, sopir profesional mengantar dengan aman dan tepat waktu. Nikmati layanan eksklusif, hanya bersama SPM Trans.",
    facilities: ['Free Wifi', '1 Toilet'],
    id: 'bus1',
    image: 'asset/bus1.png',
    location: 'Pasuruan, Indonesia',
    owner: listUser[0],
    price: 230,
    rating: 4.5,
    title: 'Bus Anugrah',
    type: 'Hot this month',
    users: 13,
  ),
  Bus(
    description:
        "Bus pariwisata semesta melaju menuju destinasi impian. Dengan kenyamanan kursi rebah dan sistem pendingin terbaru, perjalanan panjang menjadi pengalaman menyenangkan. Jetbus 5 membawa setiap penumpang pada petualangan tak terlupakan. Di balik kemudi, sopir profesional mengantar dengan aman dan tepat waktu. Nikmati layanan eksklusif, hanya bersama SPM Trans.",
    facilities: ['Free Wifi', '1 Toilet'],
    id: 'bus2',
    image: 'asset/bus2.png',
    location: 'Pasuruan, Indonesia',
    owner: listUser[1],
    price: 173,
    rating: 4.5,
    title: 'Bus Bismillah',
    type: 'Great Bus',
    users: 40,
  ),
];
final listBusNear = [
  Bus(
    description:
        "Bus pariwisata semesta melaju menuju destinasi impian. Dengan kenyamanan kursi rebah dan sistem pendingin terbaru, perjalanan panjang menjadi pengalaman menyenangkan. Jetbus 5 membawa setiap penumpang pada petualangan tak terlupakan. Di balik kemudi, sopir profesional mengantar dengan aman dan tepat waktu. Nikmati layanan eksklusif, hanya bersama SPM Trans.",
    facilities: ['Free Wifi', '1 Toilet'],
    id: 'bus3',
    image: 'asset/bus3.png',
    location: 'Pasuruan, Indonesia',
    owner: listUser[2],
    price: 221,
    rating: 4.5,
    title: 'Bus Semesta',
    type: 'Pure',
    users: 39,
  ),
  Bus(
    description:
        "Bus pariwisata semesta melaju menuju destinasi impian. Dengan kenyamanan kursi rebah dan sistem pendingin terbaru, perjalanan panjang menjadi pengalaman menyenangkan. Jetbus 5 membawa setiap penumpang pada petualangan tak terlupakan. Di balik kemudi, sopir profesional mengantar dengan aman dan tepat waktu. Nikmati layanan eksklusif, hanya bersama SPM Trans.",
    facilities: ['Free Wifi', '1 Toilet'],
    id: 'bus4',
    image: 'asset/bus4.png',
    location: 'Pasuruan, Indonesia',
    owner: listUser[1],
    price: 180,
    rating: 4.5,
    title: 'Bus Pertiwi',
    type: 'Pure',
    users: 21,
  ),
  Bus(
    description:
        "Bus pariwisata semesta melaju menuju destinasi impian. Dengan kenyamanan kursi rebah dan sistem pendingin terbaru, perjalanan panjang menjadi pengalaman menyenangkan. Jetbus 5 membawa setiap penumpang pada petualangan tak terlupakan. Di balik kemudi, sopir profesional mengantar dengan aman dan tepat waktu. Nikmati layanan eksklusif, hanya bersama SPM Trans.",
    facilities: ['Free Wifi', '1 Toilet'],
    id: 'bus5',
    image: 'asset/bus5.png',
    location: 'Pasuruan, Indonesia',
    owner: listUser[0],
    price: 200,
    rating: 4.5,
    title: 'Bus Barokah',
    type: 'Pure',
    users: 30,
  ),
];
