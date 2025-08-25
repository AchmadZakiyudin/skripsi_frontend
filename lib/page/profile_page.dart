import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = 'nama';
  String telepon = 'telepon';
  final namaController = TextEditingController();
  final teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        nama = doc['nama'] ?? '';
        telepon = doc['telepon'] ?? '';
        namaController.text = nama;
        teleponController.text = telepon;
      });
    }
  }

  Future<void> updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'nama': namaController.text,
          'telepon': teleponController.text,
        }, SetOptions(merge: true));
        setState(() {
          nama = namaController.text;
          telepon = teleponController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    children: [
                      const Icon(Icons.account_circle,
                          size: 80, color: Colors.lightBlueAccent),
                      const SizedBox(height: 16),
                      // Tampilkan nama yang sudah diisi
                      Text(
                        nama,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // Tampilkan nomor telepon yang sudah diisi
                      Text(
                        telepon,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Field edit nama
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: "Nama Lengkap",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Field edit telepon
                      TextField(
                        controller: teleponController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Nomor Telepon",
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tombol simpan perubahan
                      ElevatedButton.icon(
                        onPressed: updateProfile,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tombol logout
                      ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
