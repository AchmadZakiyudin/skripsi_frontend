// import yang diperlukan
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_bus/model/bus.dart';
import 'package:booking_bus/page/home_page.dart';

class PesananPage extends StatefulWidget {
  final Bus bus;
  final String nama;
  final String lokasi;
  final String tujuan;
  final String telepon;
  final String tanggal;
  final String harga;

  const PesananPage({
    Key? key,
    required this.bus,
    required this.nama,
    required this.lokasi,
    required this.tujuan,
    required this.telepon,
    required this.tanggal,
    required this.harga,
    required idPesanan,
  }) : super(key: key);

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  File? buktiTransfer;
  int? idPesanan;
  String? buktiImageUrl;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => buktiTransfer = File(picked.path));
    }
  }

  Future<void> simpanPesanan() async {
    final harga = widget.bus.harga ?? '0';
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'dummy-uid';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://azakiyudin.my.id/api/pesanan'),
    );

    request.fields.addAll({
      'uid': uid,
      'nama': widget.nama,
      'lokasi': widget.lokasi,
      'tujuan': widget.tujuan,
      'telepon': widget.telepon,
      'tanggal': widget.tanggal,
      'nama_bus': widget.bus.title ?? '-',
      'harga': harga,
    });

    if (buktiTransfer != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'bukti_transfer',
        buktiTransfer!.path,
      ));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseData);
      setState(() {
        idPesanan = data['data']['id'];
        buktiImageUrl = data['data']['bukti_transfer'];
      });
    } else {
      throw Exception("Gagal simpan: $responseData");
    }
  }

  void handleSelesai() async {
    if (isLoading) return;
    try {
      setState(() => isLoading = true);
      await simpanPesanan();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final harga = widget.harga;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rincian Pesanan"),
        backgroundColor: const Color(0xFF60C0F0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItem("Nama", widget.nama),
                  _buildItem("Lokasi Penjemputan", widget.lokasi),
                  _buildItem("Tujuan", widget.tujuan),
                  _buildItem("Nomor Telepon", widget.telepon),
                  _buildItem("Tanggal", widget.tanggal),
                  _buildItem("Bus", widget.bus.title ?? "-"),
                  _buildItem("Harga", "Rp $harga"),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Pembayaran",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildItem("No. Rekening", "1934519336"),
                  _buildItem("A.N", "Lutfida Isnaini"),
                  _buildItem("Nomor HP", "083126570958"),
                  const SizedBox(height: 10),
                  const Text("Upload Bukti Transfer",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Tampilkan gambar bukti transfer jika ada
                  if (buktiTransfer != null)
                    Image.file(buktiTransfer!, height: 150)
                  else if (buktiImageUrl != null && buktiImageUrl!.isNotEmpty)
                    Image.network(
                      'https://azakiyudin.my.id/$buktiImageUrl',
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text("Gagal menampilkan gambar"),
                    )
                  else
                    const Text("Belum ada bukti transfer"),
                  TextButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.upload),
                    label: const Text("Pilih Gambar"),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: handleSelesai,
                      icon: const Icon(Icons.check),
                      label: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Selesai"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 130,
              child: Text(
                "$label:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
