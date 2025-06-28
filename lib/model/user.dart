class User {
  String? id;
  String? name;
  String? image;
  double? rating;
  int? offer;

  User({this.id, this.image, this.name, this.offer, this.rating});
}

final listUser = [
  User(
    id: 'user1',
    image: 'asset/user1.png',
    name: 'Tom',
    offer: 234,
    rating: 5,
  ),
  User(
    id: 'user2',
    image: 'asset/user2.png',
    name: 'Jerry',
    offer: 135,
    rating: 4.5,
  ),
  User(
    id: 'user3',
    image: 'asset/user3.png',
    name: 'Spike',
    offer: 23,
    rating: 4,
  ),
];
