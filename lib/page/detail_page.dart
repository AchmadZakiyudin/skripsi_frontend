import 'package:booking_bus/model/bus.dart';
import 'package:booking_bus/page/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailPage extends StatelessWidget {
  final Bus bus;
  const DetailPage({Key? key, required this.bus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  bus.image!,
                  fit: BoxFit.cover,
                  height: 400,
                  width: double.maxFinite,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '\$ ${bus.price!}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          ' / ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'night',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(bus.rating!.toString()),
                        const SizedBox(width: 8),
                        RatingBar.builder(
                          initialRating: bus.rating!,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                          ignoreGestures: true,
                          itemSize: 15,
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bus.title!,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bus.location!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          bus.owner!.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: bus.facilities!.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(e),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    bus.description!,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
      // ...existing code...
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: Colors.indigo[900],
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPage(bus: bus),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                'Book this bus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
// ...existing code...
    );
  }
}
