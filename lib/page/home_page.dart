import 'package:booking_bus/controller/auth_controller.dart';
import 'package:booking_bus/model/bus.dart';
// import 'package:booking_bus/model/user.dart';
import 'package:booking_bus/page/detail_page.dart';
import 'package:booking_bus/page/detail_pesanan.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNav = 0;

  final List _bottomNav = [
    {
      'icon': Icons.home,
      'icon_off': Icons.home_outlined,
      'label': 'Home',
    },
    {
      'icon': Icons.receipt,
      'icon_off': Icons.receipt_outlined,
      'label': 'Pesanan',
    },
    {
      'icon': Icons.favorite,
      'icon_off': Icons.favorite_border,
      'label': 'Favorite',
    },
    {
      'icon': 'asset/profile.png',
      'icon_off': 'asset/profile.png',
      'label': 'Profile',
    },
  ];

  final authC = Get.find<AuthController>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),
      const DetailPesananPage(),
      const Center(child: Text('Favorite')),
      const Center(child: Text('Profile')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentNav]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNav,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue[300],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) => setState(() => _currentNav = value),
        items: _bottomNav.map((e) {
          return BottomNavigationBarItem(
            icon: e['label'] == 'Profile'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      e['icon_off'],
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(e['icon_off']),
            activeIcon: e['label'] == 'Profile'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      e['icon'],
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(e['icon']),
            label: e['label'],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
            child: Row(
              children: [
                const Text('SPM Trans',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: authC.signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    elevation: 2,
                  ),
                  child: const Icon(Icons.logout, color: Colors.white),
                ),
                const Spacer(),
                const Icon(Icons.search, size: 30),
              ],
            ),
          ),
          busTop(),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'New Bus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 16),
          busNear(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget busTop() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: listbusTop.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Bus bus = listbusTop[index];
          return GestureDetector(
            onTap: () => Get.to(() => DetailPage(bus: bus)),
            child: Container(
              width: 300,
              margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 0,
                  index == listbusTop.length - 1 ? 16 : 8, 0),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            bus.image!,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              bus.type!,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bus.title!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bus.location!.split(', ').first,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget busNear() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        itemCount: listBusNear.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Bus bus = listBusNear[index];
          return GestureDetector(
            onTap: () => Get.to(() => DetailPage(bus: bus)),
            child: Container(
              width: 300,
              margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 0,
                  index == listBusNear.length - 1 ? 16 : 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            bus.image!,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(18),
                                topLeft: Radius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bus.title ?? "-",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bus.location?.split(', ').first ?? "-",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
